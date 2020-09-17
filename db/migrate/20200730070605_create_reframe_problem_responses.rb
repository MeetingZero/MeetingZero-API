class CreateReframeProblemResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :reframe_problem_responses do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.text :response_text
      t.boolean :is_original_problem, default: false
      t.integer :original_problem_response_id

      t.timestamps
    end
  end
end
