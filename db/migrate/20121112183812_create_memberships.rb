class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, null: false
      t.references :group, null: false

      t.timestamps
    end

    add_index :memberships, :user_id
    add_index :memberships, :group_id
  end
end
