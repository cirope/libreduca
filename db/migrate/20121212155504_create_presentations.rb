class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :file, null: false
      t.string :content_type, null: false
      t.integer :file_size, null: false
      t.references :user, null: false
      t.references :homework, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :presentations, :user_id
    add_index :presentations, :homework_id
  end
end
