class SolutionResponse < ApplicationRecord
  has_many :solution_response_priorities, dependent: :destroy

  def self.get_solutions_for_voting(workshop_id)
    solutions_for_voting = []

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

      solution.update(assessment_category: assessment_category)
    end

    run_1 = SolutionResponse
    .where("average_impact_level > 5 AND average_effort_level <= 5")

    if run_1.length > 0
      return run_1
    end

    run_2 = SolutionResponse
    .where("average_impact_level >= 4 AND average_effort_level <= 5")

    if run_2.length > 0
      return run_2
    end

    run_3 = SolutionResponse
    .where("average_impact_level >= 4 AND average_effort_level <= 6")

    if run_3.length > 0
      return run_3
    end
  end
end
