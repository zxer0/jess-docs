class RemoveParentIdFromSpecs < ActiveRecord::Migration
  def change
    remove_column :specs, :parent_id
  end
end
