class CreateWorkshopStages < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_stages do |t|
      t.string :key
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
