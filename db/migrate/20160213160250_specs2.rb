class Specs2 < ActiveRecord::Migration
  def change
    change_table :specs do |t|
      
      t.column :parent_id, :integer
      
    end
  end
end
