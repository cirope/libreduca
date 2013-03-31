class DropBlocks < ActiveRecord::Migration
  def change
    drop_table :blocks
  end
end
