class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.decimal :score, precision: 5, scale: 2
      t.decimal :multiplier, precision: 5, scale: 2
      t.string :description
      t.integer :lock_version, null: false, default: 0
      t.references :teach, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :scores, :teach_id
    add_index :scores, :user_id
  end
end
