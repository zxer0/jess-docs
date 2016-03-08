class Role < ActiveRecord::Base
    has_many :users
    
    def self.admin
        find_by!(:name => 'admin')
    end
    
    def self.write
        find_by!(:name => 'write')
    end
    
    def self.view_only
        find_by!(:name => 'view_only')
    end
    
    def self.none
        find_by!(:name => 'none')
    end
end
