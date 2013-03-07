class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user, null: false
      t.references :conversation, null: false

      t.timestamps
    end

    add_index :participants, :user_id
    add_index :participants, :conversation_id
  end
end
