class Workshop < ApplicationRecord
  has_many :workshop_directors, dependent: :destroy
  has_many :workshop_members, dependent: :destroy
  has_many :what_is_working_responses, dependent: :destroy
  has_many :problem_responses, dependent: :destroy
  has_many :problem_votes, dependent: :destroy
  has_many :solution_response_priorities, dependent: :destroy
  
  before_create :generate_workshop_token

  def generate_workshop_token
    self.workshop_token = loop do
      random_token = SecureRandom.hex(5)

      break random_token unless Workshop.exists?(workshop_token: random_token)
    end
  end

  def self.find_by_token(workshop_token)
    return Workshop
    .where(workshop_token: workshop_token)
    .first
  end
end
