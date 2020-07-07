class CreateWorkshopDirectors < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_directors do |t|
      t.integer :workshop_id
      t.integer :workshop_stage_id
      t.integer :workshop_stage_step_id
      t.boolean :completed, default: false
      t.datetime :workshop_stage_step_start_time
      t.datetime :workshop_stage_step_expire_time

      t.timestamps
    end
  end
end
