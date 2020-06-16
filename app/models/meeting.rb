class Meeting < ApplicationRecord
  has_many :meeting_directors, dependent: :destroy
end
