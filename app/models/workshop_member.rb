class WorkshopMember < ApplicationRecord
  belongs_to :workshop
  belongs_to :user
end
