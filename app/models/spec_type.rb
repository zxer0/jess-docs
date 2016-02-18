class SpecType < ActiveRecord::Base
    
    validates_presence_of :name
    
    has_many :specs, dependent: :destroy
    
    def self.it
        SpecType.find_by!(:name => 'it')
    end
    
    def self.describe
        SpecType.find_by!(:name => 'describe')
    end
    
end
