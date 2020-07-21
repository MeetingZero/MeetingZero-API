class CreateProblemVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_votes do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.integer :problem_response_id
      t.integer :vote_number

      t.timestamps
    end
  end
end
