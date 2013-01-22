class MakeCommentsPolymorphic < ActiveRecord::Migration
  def change
    remove_index :comments, :forum_id

    rename_column :comments, :forum_id, :commentable_id

    remove_column :comments, :info

    change_table :comments do |t|
      t.string :commentable_type, null: false, default: Forum.to_s
      t.integer :votes_positives_count, null: false, default: 0
      t.integer :votes_negatives_count, null: false, default: 0
    end

    change_column_default :comments, :commentable_type, nil

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
