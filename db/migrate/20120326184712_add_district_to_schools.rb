class AddDistrictToSchools < ActiveRecord::Migration
  def change
    change_table :schools do |t|
      t.references :district
    end
    
    add_index :schools, :district_id
  end
end
