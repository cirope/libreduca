class AddDescriptionToTeaches < ActiveRecord::Migration
  def change
    add_column :teaches, :description, :text
  end
end
