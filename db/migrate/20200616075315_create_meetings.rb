class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.text :purpose

      t.timestamps
    end
  end
end
