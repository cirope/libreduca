class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.text :content
      t.integer :position, default: 0
      t.integer :lock_version, null: false, default: 0
      t.integer :blockable_id
      t.string  :blockable_type

      t.timestamps
    end
  end
end
