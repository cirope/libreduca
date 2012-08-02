class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name, null: false
      t.text :topic, null: false
      t.references :user, null: false
      t.references :owner, polymorphic: true, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :forums, :name
    add_index :forums, :user_id
    add_index :forums, :owner_id
  end
end
