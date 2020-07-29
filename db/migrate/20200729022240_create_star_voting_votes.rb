class CreateStarVotingVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :star_voting_votes do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.string :resource_model_name
      t.integer :resource_id
      t.integer :vote_number

      t.timestamps
    end
  end
end
