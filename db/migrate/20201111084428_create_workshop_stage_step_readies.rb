class CreateWorkshopStageStepReadies < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_stage_step_readies do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.integer :workshop_director_id

      t.timestamps
    end
  end
end
