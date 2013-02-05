class AddActiveToJobs < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.boolean :active, null: false, default: true
    end
  end
end
