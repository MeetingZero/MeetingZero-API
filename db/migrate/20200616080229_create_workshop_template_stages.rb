class CreateWorkshopTemplateStages < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_template_stages do |t|
      t.integer :workshop_template_id
      t.integer :workshop_stage_id

      t.timestamps
    end
  end
end
