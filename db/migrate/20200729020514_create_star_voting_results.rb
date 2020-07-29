class CreateStarVotingResults < ActiveRecord::Migration[6.0]
  def change
    create_table :star_voting_results do |t|
      t.integer :workshop_id
      t.string :model_name
      t.integer :round_1_runner_up_resource_id
      t.integer :round_1_runner_up_tally
      t.integer :round_1_winner_resource_id
      t.integer :round_1_winner_tally
      t.integer :runoff_runner_up_resource_id
      t.integer :runoff_runner_up_tally
      t.integer :runoff_winner_resource_id
      t.integer :runoff_winner_tally

      t.timestamps
    end
  end
end
