class AddVotesCountToNews < ActiveRecord::Migration
  def change
    add_column :news, :votes_count, :integer, null: false, default: 0

    remove_column :news, :votes_positives_count
    remove_column :news, :votes_negatives_count
  end
end
