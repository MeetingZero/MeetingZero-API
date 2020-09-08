class CreateSolutionResponsePriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :solution_response_priorities do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.integer :solution_response_id
      t.integer :impact_level
      t.integer :effort_level

      t.timestamps
    end
  end
end
