class CreateProblemVoteResults < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_vote_results do |t|
      t.integer :workshop_id
      t.integer :round_1_runner_up_problem_response_id
      t.integer :round_1_runner_up_tally
      t.integer :round_1_winner_problem_response_id
      t.integer :round_1_winner_tally
      t.integer :runoff_runner_up_problem_response_id
      t.integer :runoff_runner_up_tally
      t.integer :runoff_winner_problem_response_id
      t.integer :runoff_winner_tally

      t.timestamps
    end
  end
end
