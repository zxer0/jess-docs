class AddIndexToTags < ActiveRecord::Migration
  def change
    add_index :tags, :spec_id, :name => 'spec_id_ix'
  end
end
