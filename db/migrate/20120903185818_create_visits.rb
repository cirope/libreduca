class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :user, null: false
      t.references :visited, polymorphic: true, null: false
      t.datetime :created_at, null: false
    end

    add_index :visits, :user_id
    add_index :visits, [:visited_id, :visited_type]
    add_index :visits, [:user_id, :visited_id, :visited_type], unique: true
  end
end
