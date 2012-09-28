class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :ip, null: false
      t.text :user_agent
      t.datetime :created_at, null: false
      t.references :user, null: false
    end

    add_index :logins, :user_id
  end
end
