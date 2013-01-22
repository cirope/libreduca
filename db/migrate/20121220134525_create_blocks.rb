class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.text :content, null: false
      t.integer :position, null: false, default: 0
      t.references :blockable, null: false, polymorphic: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :blocks, [:blockable_id, :blockable_type]
  end
end
