class CreateKinships < ActiveRecord::Migration
  def change
    create_table :kinships do |t|
      t.string :kin
      t.integer :lock_version, null: false, default: 0
      t.references :user
      t.references :relative

      t.timestamps
    end

    add_index :kinships, :user_id
    add_index :kinships, :relative_id
  end
end
