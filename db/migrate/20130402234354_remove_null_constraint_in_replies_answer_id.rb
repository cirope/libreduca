class RemoveNullConstraintInRepliesAnswerId < ActiveRecord::Migration
  def change
    change_column :replies, :answer_id, :integer, null: true
  end
end
