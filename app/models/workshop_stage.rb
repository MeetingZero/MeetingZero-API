class WorkshopStage < ApplicationRecord
  has_many :workshop_stage_steps, dependent: :destroy
end
