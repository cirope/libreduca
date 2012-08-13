class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name, null: false
      t.string :identification
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    
    add_index :institutions, :name
    add_index :institutions, :identification, unique: true
  end
end
