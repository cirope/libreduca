class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :user, null: false
      t.references :forum, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :forum_id
  end
end
