class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.column :user_id, :integer, :null => false
      t.column :role_id, :integer
      t.timestamps null: false
    end
  end
end
