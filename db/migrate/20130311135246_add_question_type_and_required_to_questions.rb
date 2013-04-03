class AddQuestionTypeAndRequiredToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.string :question_type, default: 'multiple_choice', null: false
      t.boolean :required, null: false, default: false
    end
  end
end
