class MeetingStage < ApplicationRecord
  has_many :meeting_stage_steps, dependent: :destroy
end
