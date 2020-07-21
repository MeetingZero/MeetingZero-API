class ProblemResponse < ApplicationRecord
  belongs_to :workshop
  has_many :problem_votes, dependent: :destroy
end
