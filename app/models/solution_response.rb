class SolutionResponse < ApplicationRecord
  has_many :solution_response_priorities, dependent: :destroy

  def self.get_solutions_for_voting(workshop_id)
    all_solutions = SolutionResponse
    .where(workshop_id: workshop_id)
    .includes(:solution_response_priorities)

    # If average for effort and impact levels doesn't exist, create it
    all_solutions.each do |solution|
      if solution.average_impact_level && solution.average_effort_level
        next
      end

      solution_impact_level_sum = solution
      .solution_response_priorities
      .inject do |sum, srp|
        sum + srp.impact_level
      end

      solution_average_impact_level = solution_impact_level_sum.to_f / solution.solution_response_priorities.length

      solution.update(average_impact_level: solution_average_impact_level)

      solution_effort_level_sum = solution
      .solution_response_priorities
      .inject do |sum, srp|
        sum + srp.effort_level
      end

      solution_average_effort_level = solution_effort_level_sum.to_f / solution.solution_response_priorities.length

      solution.update(average_effort_level: solution_average_effort_level)
    end

    return all_solutions
  end
end
