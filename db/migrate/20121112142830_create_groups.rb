class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.references :institution, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :groups, :name
    add_index :groups, :institution_id
  end
end
