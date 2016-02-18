class CreateSpecs < ActiveRecord::Migration
  def change
    create_table :specs do |t|

      t.timestamps null: false
      
      t.column :description, :string, :null => false
      t.column :spec_type_id, :integer
    end
  end
end
