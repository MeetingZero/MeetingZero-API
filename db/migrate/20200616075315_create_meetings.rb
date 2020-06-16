class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.integer :host_id
      t.text :purpose

      t.timestamps
    end
  end
end
