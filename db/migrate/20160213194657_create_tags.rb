class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|

      t.timestamps null: false
      t.column :spec_id, :integer
      t.column :tag_type_id, :integer
    end
  end
end
