class CreateTagTypes < ActiveRecord::Migration
  def change
    create_table :tag_types do |t|

      t.timestamps null: false
      t.column :name, :string
    end
    
    TagType.create :name => 'automated'
  end
end
