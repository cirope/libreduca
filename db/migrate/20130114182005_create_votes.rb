class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote_flag, null: false
      t.references :user, null: false
      t.references :votable, null:false, polymorphic: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :votes, :user_id
    add_index :votes, [:votable_id, :votable_type]
  end
end
