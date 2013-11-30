class AddDistrictToInstitutions < ActiveRecord::Migration
  def change
    change_table :institutions do |t|
      t.references :district
    end

    add_index :institutions, :district_id
  end
end
