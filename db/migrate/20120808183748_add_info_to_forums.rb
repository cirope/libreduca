class AddInfoToForums < ActiveRecord::Migration
  def change
    add_column :forums, :info, :text
  end
end
