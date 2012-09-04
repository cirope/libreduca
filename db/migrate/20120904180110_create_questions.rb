class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content, null: false
      t.references :survey, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :questions, :survey_id
  end
end
