class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :identification
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    
    add_index :schools, :name
    add_index :schools, :identification, unique: true
  end
end
