class SpecTypes < ActiveRecord::Migration
  def self.up
    drop_table :spec_types
    create_table :spec_types do |t|
      
      t.column :name, :string
    end
    
    SpecType.create :name => 'it'
    SpecType.create :name => 'describe'
  end

  def self.down
    drop_table :spec_types
  end
end
