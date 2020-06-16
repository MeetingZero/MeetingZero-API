class CreateMeetingTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_templates do |t|
      t.string :key
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
