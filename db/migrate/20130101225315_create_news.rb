class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.text :description
      t.text :body
      t.integer :lock_version, null: false, default: 0
      t.references :institution

      t.timestamps
    end
    add_index :news, :title
    add_index :news, :institution_id
  end
end
