class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :teach, null: false
      t.references :user, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    
    add_index :enrollments, :teach_id
    add_index :enrollments, :user_id
  end
end
