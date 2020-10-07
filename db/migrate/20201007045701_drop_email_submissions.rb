class DropEmailSubmissions < ActiveRecord::Migration[6.0]
  def change
    drop_table :email_submissions
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
