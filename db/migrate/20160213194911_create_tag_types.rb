class CreateTagTypes < ActiveRecord::Migration
  def change
    create_table :tag_types do |t|

      t.timestamps null: false
      t.column :name, :string
      t.column :color, :string
    end
    
    TagType.create :name => 'automated', :color=> '#0000FF'
  end
end
