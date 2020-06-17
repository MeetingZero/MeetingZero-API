class CreateWorkshopDirectors < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_directors do |t|
      t.integer :workshop_id
      t.integer :workshop_stage_id
      t.integer :workshop_stage_step_id
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
