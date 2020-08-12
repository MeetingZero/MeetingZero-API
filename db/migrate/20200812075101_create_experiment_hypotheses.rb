class CreateExperimentHypotheses < ActiveRecord::Migration[6.0]
  def change
    create_table :experiment_hypotheses do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.text :we_believe_text
      t.text :will_result_in_text
      t.text :succeeded_when_text

      t.timestamps
    end
  end
end
