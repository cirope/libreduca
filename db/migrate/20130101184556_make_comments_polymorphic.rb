class MakeCommentsPolymorphic < ActiveRecord::Migration
  def change
    remove_index :comments, :forum_id

    add_column :comments, :commentable_type, :string, null: false, default: Forum.to_s
    change_column_default :comments, :commentable_type, nil

    rename_column :comments, :forum_id, :commentable_id
    remove_column :comments, :info

    add_column :votes_positives_count, null: false, default: 0
    add_column :votes_negatives_count, null: false, default: 0

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
