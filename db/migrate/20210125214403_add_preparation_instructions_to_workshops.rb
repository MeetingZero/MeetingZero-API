class AddPreparationInstructionsToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :preparation_instructions, :text
  end
end
