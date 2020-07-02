class WorkshopDirector < ApplicationRecord
  belongs_to :workshop
  belongs_to :workshop_stage
  belongs_to :workshop_stage_step

  def self.get_ordered(workshop_token)
    return Workshop
    .where(workshop_token: workshop_token)
    .first
    .workshop_directors
    .all
    .order(id: :asc)
  end

  def self.get_current(workshop_token)
    return Workshop
    .where(workshop_token: workshop_token)
    .first
    .workshop_directors
    .where(completed: false)
    .order(id: :asc)
    .first
  end
end
