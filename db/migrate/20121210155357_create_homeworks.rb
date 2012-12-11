class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.string :name, null: false
      t.text :description
      t.date :closing_at
      t.references :content, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :homeworks, :content_id
    add_index :homeworks, :closing_at
  end
end
