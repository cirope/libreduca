class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name, null: false
      t.references :content, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :surveys, :content_id
  end
end
