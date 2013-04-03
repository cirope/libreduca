class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :comments_count, null: false, default: 0
      t.references :conversable, null: false, polymorphic: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :conversations, [:conversable_id, :conversable_type]
  end
end
