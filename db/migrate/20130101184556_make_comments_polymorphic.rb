class MakeCommentsPolymorphic < ActiveRecord::Migration
  def change
    remove_index :comments, :forum_id

    add_column :comments, :commentable_type, :string, null: false, default: Forum.to_s
    change_column_default :comments, :commentable_type, nil

    rename_column :comments, :forum_id, :commentable_id

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
