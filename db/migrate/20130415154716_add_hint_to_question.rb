class AddHintToQuestion < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.text :hint
    end
  end
end
