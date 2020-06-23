class WorkshopDirector < ApplicationRecord
  belongs_to :workshop
  belongs_to :workshop_stage
  belongs_to :workshop_stage_step
end
