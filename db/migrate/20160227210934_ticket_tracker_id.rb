class TicketTrackerId < ActiveRecord::Migration
  def change
    add_column :tickets, :tracker_id, :string
    
    Ticket.all.each do |ticket|
      tracker_id = ticket.name.strip
      if tracker_id.first === '#'
          tracker_id.slice!(0)
      end
      ticket.update!(:tracker_id => tracker_id)
    end
    
  end
end
