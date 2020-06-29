class CreateWorkshopMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_members do |t|
      t.integer :workshop_id
      t.integer :user_id
      t.boolean :online, default: false

      t.timestamps
    end
  end
end
