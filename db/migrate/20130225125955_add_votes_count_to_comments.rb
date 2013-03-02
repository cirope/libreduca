class AddVotesCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :votes_count, :integer, null: false, default: 0

    remove_column :comments, :votes_positives_count
    remove_column :comments, :votes_negatives_count
  end
end
