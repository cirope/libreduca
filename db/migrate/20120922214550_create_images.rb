class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name, null: false
      t.string :file, null: false
      t.string :content_type, null: false
      t.integer :file_size, null: false
      t.references :institution, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :images, :institution_id
  end
end
