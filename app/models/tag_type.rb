class TagType < ActiveRecord::Base
    
    validates_presence_of :name
    validates_uniqueness_of :name
    validates_presence_of :color
    
    has_many :tags, dependent: :destroy
    
    default_scope { order("LOWER(name)") }
    
    before_create :downcase
    
    private
        def downcase
            self.name.downcase!
        end
end
