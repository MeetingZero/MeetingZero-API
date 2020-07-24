class CreateWorkshopStageSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_stage_steps do |t|
      t.integer :workshop_stage_id
      t.string :key
      t.string :name
      t.integer :default_time_limit
      t.text :description
      t.boolean :discussion_allowed, default: false

      t.timestamps
    end
  end
end
