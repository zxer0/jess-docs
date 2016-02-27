class AddIndexToSpecs < ActiveRecord::Migration
  def change
    add_index :specs, :project_id, :name => 'project_id_ix'
  end
end
