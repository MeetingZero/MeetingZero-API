class CreateProblemResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_responses do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.text :response_text

      t.timestamps
    end
  end
end
