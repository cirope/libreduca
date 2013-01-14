class AddOwnerToImages < ActiveRecord::Migration
  def change
    change_table(:images) do |t|
      t.references :owner, polymorphic: true
    end

    add_index :images, [:owner_id, :owner_type]
  end
end
