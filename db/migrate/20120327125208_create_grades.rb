class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :name, null: false
      t.integer :lock_version, null: false, default: 0
      t.references :school

      t.timestamps
    end
    
    add_index :grades, :school_id
  end
end
