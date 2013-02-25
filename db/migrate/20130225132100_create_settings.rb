class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.references :configurable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :settings, [:configurable_id, :configurable_type]
  end
end
