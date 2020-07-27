class ProblemVote < ApplicationRecord
  belongs_to :workshop

  def self.calculate_votes(workshop_id)
    problem_vote_results = ProblemVoteResult
    .where(workshop_id: workshop_id)
    .first

    # If results were previously calculated, just return the results
    if problem_vote_results
      return self.create_payload(problem_vote_results)
    end

    problems_votes = ProblemVote
    .where(workshop_id: workshop_id)

    round_1_tally = {}

    # Build tally of sum of votes matched to problem_response_id's
    problems_votes.each do |vote|
      if round_1_tally[vote.problem_response_id]
        round_1_tally[vote.problem_response_id] = round_1_tally[vote.problem_response_id] + vote.vote_number
      else
        round_1_tally[vote.problem_response_id] = vote.vote_number
      end
    end

    # Sort by descending order and then take the top two highest items
    round_1_winners = round_1_tally
    .sort_by { |k, v| v }
    .reverse
    .take(2)

    runoff_tally = {}

    runoff_tally[round_1_winners[0][0]] = 0
    runoff_tally[round_1_winners[1][0]] = 0

    # Group votes by user ID
    problems_votes
    .group_by { |pv| pv.user_id }
    .each do |user_id, votes|
      vote_map = {}

      # Build vote map to easily look up vote_number for any user's problem_response_id
      votes.each do |vote|
        vote_map[vote.problem_response_id] = vote.vote_number
      end

      if vote_map[round_1_winners[0][0]] > vote_map[round_1_winners[1][0]]
        votes.each do |vote|
          # If the user voted higher for the round 1 winner, assign all of their votes to that problem
          runoff_tally[round_1_winners[0][0]] = runoff_tally[round_1_winners[0][0]] + vote.vote_number
        end
      else
        votes.each do |vote|
          # If the user voted higher for the round 1 runner up, assign all of their votes to that problem
          runoff_tally[round_1_winners[1][0]] = runoff_tally[round_1_winners[1][0]] + vote.vote_number
        end
      end
    end

    # Sort the runoff winners
    runoff_winners = runoff_tally
    .sort_by { |k, v| v }
    .reverse

    problem_vote_results = ProblemVoteResult
    .create(
      workshop_id: workshop_id,
      round_1_runner_up_problem_response_id: round_1_winners[1][0],
      round_1_runner_up_tally: round_1_winners[1][1],
      round_1_winner_problem_response_id: round_1_winners[0][0],
      round_1_winner_tally: round_1_winners[0][1],
      runoff_runner_up_problem_response_id: runoff_winners[1][0],
      runoff_runner_up_tally: runoff_winners[1][1],
      runoff_winner_problem_response_id: runoff_winners[0][0],
      runoff_winner_tally: runoff_winners[0][1]
    )

    return create_payload(problem_vote_results)
  end

  def self.create_payload(problem_vote_results)
    return {
      round_1_winner: {
        problem_response: ProblemResponse.find(problem_vote_results.round_1_winner_problem_response_id),
        tally: problem_vote_results.round_1_winner_tally
      },
      round_1_runner_up: {
        problem_response: ProblemResponse.find(problem_vote_results.round_1_runner_up_problem_response_id),
        tally: problem_vote_results.round_1_runner_up_tally
      },
      runoff_winner: {
        problem_response: ProblemResponse.find(problem_vote_results.runoff_winner_problem_response_id),
        tally: problem_vote_results.runoff_winner_tally
      },
      runoff_runner_up: {
        problem_response: ProblemResponse.find(problem_vote_results.runoff_runner_up_problem_response_id),
        tally: problem_vote_results.runoff_runner_up_tally
      }
    }
  end
end
