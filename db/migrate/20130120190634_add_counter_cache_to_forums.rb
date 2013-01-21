class AddCounterCacheToForums < ActiveRecord::Migration
  def change
    add_column :forums, :comments_count, :integer, null: false, default: 0
  end
end
