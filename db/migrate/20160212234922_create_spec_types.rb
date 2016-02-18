class CreateSpecTypes < ActiveRecord::Migration
  def change
    create_table :spec_types do |t|

      t.timestamps null: false
      
      t.column :name, :string
    end
    
    SpecType.create :name => 'it'
    SpecType.create :name => 'describe'
  end
end
