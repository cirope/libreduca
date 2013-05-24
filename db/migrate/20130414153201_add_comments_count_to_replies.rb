class AddCommentsCountToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :comments_count, :integer, null: false, default: 0
  end
end
