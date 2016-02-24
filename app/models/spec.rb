class Spec < ActiveRecord::Base
    has_many :children, class_name: "Spec", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Spec"
    
    belongs_to :spec_type
    belongs_to :project
    has_many :tags, dependent: :destroy
    
    validates_presence_of :description
    validates_presence_of :spec_type_id
    
    def top?
        self.parent_id.nil?
    end
    
    def bottom?
        spec_type === SpecType.it
    end
    
    def oldest_parent
        if self.parent.nil?
            return self
        end
        
        self.parent.oldest_parent
    end
    
    def only_child?
       self.oldest_parent.id == self.id && !self.children.any?
    end
    
    def self.get_top_level(specs_array=nil)
        if(specs_array.nil?)
            return Spec.where(:parent_id => nil)
        end
        
        specs_array.select{ |spec| spec.parent_id == nil}
    end
    
    def self.filter_by_tag_type(tag_type_id=nil, spec_list=nil)
        spec_list = spec_list || Spec.all
        
        if tag_type_id.nil? || tag_type_id == ""
            return spec_list
        end
        
        tags = Tag.where(:tag_type_id => tag_type_id)
        
        spec_id_list = tags.map(&:spec_id)
        
        tagged_specs = spec_list.where(:id => spec_id_list)
        
        specs_to_print = []
        tagged_specs.each do |tagged_spec|
            specs_to_print.concat tagged_spec.heritage
            specs_to_print.concat tagged_spec.children
        end
        specs_to_print
    end
    
    def self.filter_by_project(project_id=nil)
        if project_id.nil?
            return Spec.all
        end
        
        Spec.where(:project_id => project_id)
    end
    
    def heritage(spec_array=nil)
        if spec_array.nil?
            spec_array = []
        end
        
        spec_array << self
        
        if(!self.top?)
            Spec.find(self.parent_id).heritage(spec_array)
        end
        
        spec_array
    end
    
    def self.parse_block(text)
        self.parse(text.split("\n"))
    end
    
    def self.parse(text_array, depth=0, previous=nil, error_count=0)
        regex = /(\t*|-*)\s*(\bdescribe\b|\bit\b)\s(.*)/
        unless text_array.any?
            return error_count
        end
        
        line = text_array.first
        tabs, spec_type, spec_description = line.scan(regex).first
        spec_depth = tabs.nil? ? 0 : tabs.length
        
        begin
            spec = Spec.create!(:description => spec_description,
                            :spec_type => SpecType.find_by!(:name=> spec_type))
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
        self.parse(text_array, spec_depth, spec, error_count)
    end
    
end
