class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :institution
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
