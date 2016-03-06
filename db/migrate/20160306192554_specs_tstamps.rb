class SpecsTstamps < ActiveRecord::Migration
  def change
    
    change_table :specs do |t|
      t.timestamps
    end
    
    Spec.all.each do |spec|
      spec.update_attributes!(:created_at => Time.now)
      spec.update_attributes!(:updated_at => Time.now)
    end
  end
end
