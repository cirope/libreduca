class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.string :file, null: false
      t.string :content_type, null: false
      t.string :file_size, null: false
      t.references :owner, polymorphic: true, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :documents, :created_at 
    add_index :documents, [:owner_id, :owner_type]
  end
end
