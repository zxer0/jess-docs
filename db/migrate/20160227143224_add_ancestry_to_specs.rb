class AddAncestryToSpecs < ActiveRecord::Migration
  def change
    add_column :specs, :ancestry, :string
    add_index :specs, :ancestry
  end
end
