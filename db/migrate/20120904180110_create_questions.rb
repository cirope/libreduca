class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content, null: false
      t.references :survey, null: false

      t.timestamps
    end

    add_index :questions, :survey_id
  end
end
