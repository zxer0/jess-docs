class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.column :name, :string, :null => false
      t.column :spec_id, :integer, :null => false
      t.timestamps null: false
    end
    
    add_index :tickets, :spec_id, :name => 'ticket_id_ix'
  end
end
