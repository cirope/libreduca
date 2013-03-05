class AddPublishedAtToNews < ActiveRecord::Migration
  def change
    add_column :news, :published_at, :datetime

    News.unscoped.find_each { |n| n.update_column(:published_at, Time.zone.now) }

    change_column_null :news, :published_at, false

    add_index :news, :published_at
  end
end
