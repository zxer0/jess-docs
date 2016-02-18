class Spec < ActiveRecord::Base
    has_many :children, class_name: "Spec", foreign_key: "parent_id"
    belongs_to :parent, class_name: "Spec"
    
    belongs_to :spec_type
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
    
    def self.filter(tag_type_id=nil)
        if tag_type_id.nil? || tag_type_id == ""
            return Spec.all
        end
        
        tags = Tag.where(:tag_type_id => tag_type_id)
        
        spec_id_list = tags.map(&:spec_id)
        
        tagged_specs = Spec.find(spec_id_list)
        
        specs_to_print = [] #Spec.find(spec_id_list) #tagged_specs
        tagged_specs.map do |tagged_spec|
            specs_to_print.concat tagged_spec.heritage
            specs_to_print.concat tagged_spec.children
        end
        specs_to_print
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
    
    # def print_tags
    #     contents = ""
    #     # @spec = Spec.find(params[:id])
    #     self.tags.each do |tag|
    #       contents << "<span class=\"tag\" style=\"background-color:#{tag.color}\">"
    #       contents << "#{tag.name}"
    #       contents << "</span> "
    #     end
        
    #     contents
    # end
end
