class CreateTeaches < ActiveRecord::Migration
  def change
    create_table :teaches do |t|
      t.date :start, null: false
      t.date :finish, null: false
      t.integer :lock_version, null: false, default: 0
      t.references :course, null: false

      t.timestamps
    end

    add_index :teaches, :start
    add_index :teaches, :finish
    add_index :teaches, :course_id
  end
end
