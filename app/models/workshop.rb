class Workshop < ApplicationRecord
  has_many :workshop_directors, dependent: :destroy
end
