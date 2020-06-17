class WorkshopTemplate < ApplicationRecord
  has_many :workshop_template_stages, dependent: :destroy
end
