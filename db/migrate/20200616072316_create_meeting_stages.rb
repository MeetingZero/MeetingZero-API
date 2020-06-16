class CreateMeetingStages < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_stages do |t|
      t.string :key
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
