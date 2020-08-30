class SolutionResponse < ApplicationRecord
  has_many :solution_response_priorities, dependent: :destroy
end
