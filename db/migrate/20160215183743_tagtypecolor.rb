class Tagtypecolor < ActiveRecord::Migration
   change_table :tag_types do |t|
      
      t.column :color, :string
      
    end
    
    TagType.all.each do |tag_type|
      tag_type.update_attributes!(:color => '#0000FF')
    end
end
