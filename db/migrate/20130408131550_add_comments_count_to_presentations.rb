class AddCommentsCountToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :comments_count, :integer, null: false, default: 0
  end
end
