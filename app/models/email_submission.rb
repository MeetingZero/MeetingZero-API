class EmailSubmission < ApplicationRecord
  validates :email, presence: true
end
