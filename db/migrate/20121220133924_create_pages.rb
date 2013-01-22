class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :institution, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :pages, :institution_id
  end
end
