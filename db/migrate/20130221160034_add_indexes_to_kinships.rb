class AddIndexesToKinships < ActiveRecord::Migration
  def change
    add_index :kinships, :kin
  end
end
