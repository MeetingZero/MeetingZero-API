class WorkshopMember < ApplicationRecord
  belongs_to :workshop
  belongs_to :user, optional: true
end
