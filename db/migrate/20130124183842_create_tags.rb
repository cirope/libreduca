class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :tagger_type, null: false
      t.references :institution, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :tags, :name
    add_index :tags, :tagger_type
    add_index :tags, :institution_id
  end
end
