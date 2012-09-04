class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :content, null: false
      t.references :question, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :answers, :question_id
  end
end
