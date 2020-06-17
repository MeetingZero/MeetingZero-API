class CreateWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :workshops do |t|
      t.integer :host_id
      t.text :purpose

      t.timestamps
    end
  end
end
