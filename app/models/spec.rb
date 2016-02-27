class Spec < ActiveRecord::Base
    # The orphan subtree is added to the parent of the deleted node.
    # If the deleted node is Root, then rootify the orphan subtree.
    has_ancestry
    
    belongs_to :spec_type
    belongs_to :project
    has_many :tags, dependent: :destroy
    has_many :tickets, dependent: :destroy
    
    alias_attribute :name, :description
    
    validates_presence_of :description
    validates_presence_of :spec_type_id
    validates_presence_of :project_id
    
    scope :with_tag_type, ->(type_id) { joins(:tags).where(tags: {tag_type_id: type_id})  }
    scope :for_project, ->(project_id) { where(:project_id => project_id) }
    scope :has_ticket, -> { joins(:tickets) }
    
    def full_ancestry_ids
        (self.path.to_a + self.descendants.to_a).map(&:id)
    end
    
    def self.all_ancestry_ids(specs)
        ids = []
        specs.map do |spec|
            ids.concat spec.full_ancestry_ids
        end
        
        ids.uniq
    end
    
    def bottom?
        spec_type === SpecType.it
    end

    def self.parse_block(text, project_id)
        self.parse_alternate(text.split("\n"), project_id)
    end
    
    def self.parse_alternate(text_array, project_id, depth=0, previous=nil, error_count=0)
        regex = /(\t*|-*)\s?(\w+)\s?(.*)/
        unless text_array.any?
            return error_count
        end
        
        line = text_array.first
        tabs, spec_type_indicator, spec_description_rest = line.scan(regex).first
        spec_depth = tabs.nil? ? 0 : tabs.length
        
        spec_description = "#{spec_type_indicator} #{spec_description_rest}"
        
        puts "spec type indicator = #{spec_type_indicator}"
        if spec_type_indicator == "should"
            spec_type = SpecType.it
        else
            spec_type = SpecType.describe
        end
        
        begin
            spec = Spec.create!(:description => spec_description,
                            :spec_type => spec_type,
                            :project_id => project_id)
            if(depth == spec_depth)
                parent_id = previous.nil? ? nil : previous.parent_id
                spec.update!(:parent_id => parent_id)
            elsif (spec_depth > depth) #deeper in, set the parent
                spec.update!(:parent_id => previous.id)
            else #spec_depth < depth. farther out... no idea
                (1+depth-spec_depth).times do #this is how far back we need to go
                    previous = previous.parent
                end
                parent_id = previous.nil? ? nil : previous.id
                spec.update!(:parent_id => parent_id)
            end
        rescue => error
            puts error.inspect
        end
        
        text_array.delete(line)
        self.parse_alternate(text_array, project_id, spec_depth, spec, error_count)
    end
    
    def self.parse(text_array, project_id, depth=0, previous=nil, error_count=0)
        regex = /(\t*|-*)\s*(\bdescribe\b|\bit\b)\s(.*)/
        unless text_array.any?
            return error_count
        end
        
        line = text_array.first
        tabs, spec_type, spec_description = line.scan(regex).first
        spec_depth = tabs.nil? ? 0 : tabs.length
        
        begin
            spec = Spec.create!(:description => spec_description,
                            :spec_type => SpecType.find_by!(:name=> spec_type),
                            :project_id => project_id)
            if(depth == spec_depth)
                parent_id = previous.nil? ? nil : previous.parent_id
                spec.update!(:parent_id => parent_id)
            elsif (spec_depth > depth) #deeper in, set the parent
                spec.update!(:parent_id => previous.id)
            else #spec_depth < depth. farther out... no idea
                (1+depth-spec_depth).times do #this is how far back we need to go
                    previous = previous.parent
                end
                parent_id = previous.nil? ? nil : previous.id
                spec.update!(:parent_id => parent_id)
            end
        rescue => error
            puts error.inspect
        end
        
        text_array.delete(line)
        self.parse(text_array, project_id, spec_depth, spec, error_count)
    end
    
end
