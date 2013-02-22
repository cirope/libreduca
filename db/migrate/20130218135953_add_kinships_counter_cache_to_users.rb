class AddKinshipsCounterCacheToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :kinships_in_chart_count, null: false, default: 0
      t.integer :inverse_kinships_in_chart_count, null: false, default: 0
    end

    User.reset_column_information

    User.find_each do |u|
      u.update_column :kinships_in_chart_count, u.kinships.for_chart.count
      u.update_column :inverse_kinships_in_chart_count, u.inverse_kinships.for_chart.count
    end
  end
end
