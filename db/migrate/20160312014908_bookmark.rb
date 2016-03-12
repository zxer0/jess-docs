class Bookmark < ActiveRecord::Migration
  def change
    change_table :specs do |t|
      t.column :bookmarked, :boolean, default: false, null: false
    end
  end
end
