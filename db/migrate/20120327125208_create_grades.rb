class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :name, null: false
      t.integer :lock_version, null: false, default: 0
      t.references :institution

      t.timestamps
    end
    
    add_index :grades, :institution_id
  end
end
