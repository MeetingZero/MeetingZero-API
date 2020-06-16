class CreateMeetingDirectors < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_directors do |t|
      t.integer :meeting_id
      t.integer :meeting_stage_id
      t.integer :meeting_stage_step_id
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
