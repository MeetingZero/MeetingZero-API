class SolutionResponse < ApplicationRecord
  has_many :solution_response_priorities, dependent: :destroy

  def self.get_solutions_for_voting(workshop_id)
    priorities_map = {}

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

      assessment_category = nil

      if solution_average_impact_level > 5 && solution_average_effort_level > 5
        assessment_category = "Make a Project"
      elsif solution_average_impact_level > 5 && solution_average_effort_level <= 5
        assessment_category = "Do Now"
      elsif solution_average_impact_level <= 5 && solution_average_effort_level > 5
        assessment_category = "Forget for Now"
      elsif solution_average_impact_level <= 5 && solution_average_effort_level <= 5
        assessment_category = "Make a Task"
      end

      if priorities_map[assessment_category]
        priorities_map[assessment_category].push(solution)
      else
        priorities_map[assessment_category] = [solution]
      end
    end

    return all_solutions
  end
end
