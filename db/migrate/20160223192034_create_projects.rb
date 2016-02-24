class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|

      t.timestamps null: false
      t.column :name, :string
    end
    
    change_table :specs do |t|
      
      t.column :project_id, :integer
      
    end
    
    Project.create!([
        {:name => 'test project'},
        {:name => 'kit check'},
        {:name => 'narc check'}
      ])
    
    Spec.all.each do |spec|
      spec.update_attributes!(:project_id => Project.first.id)
    end
  end
end
