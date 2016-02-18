class Specs < ActiveRecord::Migration
  def self.up
    drop_table :specs
    create_table :specs do |t|
      
      t.column :description, :string, :null => false
      t.column :spec_type_id, :integer
      
    end
  end

  def self.down
    drop_table :specs
  end
  
end
