class RemoveVoteFlagFromVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :vote_flag
  end
end
