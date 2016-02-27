class Ticket < ActiveRecord::Base
    belongs_to :spec
    before_create :parse_tracker_id
    
    validates_presence_of :spec_id
    validates_presence_of :name
    
    validates_uniqueness_of :name, :scope => :spec_id
    
    def url
        tracker_url = "https://www.pivotaltracker.com/story/show/"
        tracker_url + self.tracker_id
    end
    
    private
        def parse_tracker_id
            tracker_id = self.name.strip
            if tracker_id.first === '#'
                tracker_id.slice!(0)
            end
            self.tracker_id = tracker_id
        end
end
