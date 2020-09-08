class SolutionResponse < ApplicationRecord
  has_many :solution_response_priorities, dependent: :destroy

  def self.get_solutions_for_voting(user_id, workshop_id)
    all_solutions = SolutionResponse
    .where(workshop_id: workshop_id)
    .includes(:solution_response_priorities)

    # If average for effort and impact levels doesn't exist, create it
    all_solutions.each do |solution|
      if solution.average_impact_level && solution.average_effort_level
        next
      end

      solution_average_impact_level = solution
      .solution_response_priorities
      .average(:impact_level)

      solution.update(average_impact_level: solution_average_impact_level)

      solution_average_effort_level = solution
      .solution_response_priorities
      .average(:effort_level)

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
      return self.create_payload(run_1, user_id, workshop_id)
    end

    run_2 = SolutionResponse
    .where("average_impact_level >= 4 AND average_effort_level <= 5")

    if run_2.length > 0
      return self.create_payload(run_2, user_id, workshop_id)
    end

    run_3 = SolutionResponse
    .where("average_impact_level >= 4 AND average_effort_level <= 6")

    if run_3.length > 0
      return self.create_payload(run_3, user_id, workshop_id)
    end
  end

  def self.create_payload(results, user_id, workshop_id)
    return results.map do |sr|
      sr
      .as_json
      .merge!({
        star_voting_vote: StarVotingVote.where(
          user_id: user_id,
          workshop_id: workshop_id,
          resource_model_name: "SolutionResponse",
          resource_id: sr.id
        ).first
      })
    end
  end
end
