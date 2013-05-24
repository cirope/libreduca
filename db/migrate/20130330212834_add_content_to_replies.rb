class AddContentToReplies < ActiveRecord::Migration
  def change
    change_table :replies do |t|
      t.text :response
    end
  end
end
