class StarVoting
  def initialize(workshop_id, model_name, votes)
    @workshop_id = workshop_id
    @workshop_stage_step_key = workshop_stage_step_key
    @model_name = model_name
    @votes = votes
  end

  def calculate_votes
    voting_results = StarVotingResult
    .where(
      model_name: @model_name,
      workshop_id: @workshop_id
    )
    .first

    # If results were previously calculated, just return the results
    if voting_results
      return create_payload(voting_results)
    end
  end

  def create_payload(voting_results)
    return {
      round_1_winner: {
        response_text: ProblemResponse.find(problem_vote_results.round_1_winner_problem_response_id),
        tally: problem_vote_results.round_1_winner_tally
      },
      round_1_runner_up: {
        response_text: ProblemResponse.find(problem_vote_results.round_1_runner_up_problem_response_id),
        tally: problem_vote_results.round_1_runner_up_tally
      },
      runoff_winner: {
        response_text: ProblemResponse.find(problem_vote_results.runoff_winner_problem_response_id),
        tally: problem_vote_results.runoff_winner_tally
      },
      runoff_runner_up: {
        response_text: ProblemResponse.find(problem_vote_results.runoff_runner_up_problem_response_id),
        tally: problem_vote_results.runoff_runner_up_tally
      }
    }
  end
end
