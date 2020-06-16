class CreateMeetingStageSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_stage_steps do |t|
      t.integer :meeting_stage_id
      t.string :key
      t.string :name
      t.integer :default_time_limit
      t.text :description

      t.timestamps
    end
  end
end
