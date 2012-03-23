class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name, null: false
      t.integer :lock_version, null: false, default: 0
      t.references :region

      t.timestamps
    end
    
    add_index :districts, :name
    add_index :districts, :region_id
  end
end
