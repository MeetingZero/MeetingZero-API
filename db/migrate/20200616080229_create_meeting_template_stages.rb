class CreateMeetingTemplateStages < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_template_stages do |t|
      t.integer :meeting_template_id
      t.integer :meeting_stage_id

      t.timestamps
    end
  end
end
