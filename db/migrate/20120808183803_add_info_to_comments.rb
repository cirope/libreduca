class AddInfoToComments < ActiveRecord::Migration
  def change
    add_column :comments, :info, :text
  end
end
