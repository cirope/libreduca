class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :lock_version, null: false, default: 0
      t.references :grade

      t.timestamps
    end
    
    add_index :courses, :grade_id
  end
end
