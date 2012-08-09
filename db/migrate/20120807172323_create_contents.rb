class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :content
      t.references :teach, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :contents, :teach_id
  end
end
