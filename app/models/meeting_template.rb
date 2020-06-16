class MeetingTemplate < ApplicationRecord
  has_many :meeting_template_stages, dependent: :destroy
end
