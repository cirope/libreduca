class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :question, null: false
      t.references :answer, null: false
      t.references :user, null: false

      t.datetime :created_at, null: false
    end

    add_index :replies, :question_id
    add_index :replies, :answer_id
    add_index :replies, :user_id
  end
end
