class CreateSolutionResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :solution_responses do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.text :response_text
      t.string :assessment_category

      t.timestamps
    end
  end
end
