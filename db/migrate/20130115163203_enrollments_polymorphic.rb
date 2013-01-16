class EnrollmentsPolymorphic < ActiveRecord::Migration
  def change
    rename_column :enrollments, :user_id, :enrollable_id
    add_column :enrollments, :enrollable_type, :string, default: 'User'

    add_index :enrollments, [:enrollable_id, :enrollable_type]
  end

  remove_index :enrollments, :user_id
end
