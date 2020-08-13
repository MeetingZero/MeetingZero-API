class CreateExperimentTaskAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :experiment_task_assignments do |t|
      t.integer :workshop_id
      t.integer :experiment_task_id
      t.integer :user_id
      t.text :assignment_text

      t.timestamps
    end
  end
end
