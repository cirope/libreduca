class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :job, null: false
      t.integer :lock_version, null: false, default: 0
      t.references :user
      t.references :institution

      t.timestamps
    end
    
    add_index :jobs, :user_id
    add_index :jobs, :institution_id
  end
end
