class ProblemVote < ApplicationRecord
  belongs_to :workshop

  def self.calculate_votes(workshop_id)
    problems_votes = ProblemVote
    .where(workshop_id: workshop_id)

    round_1_tally = {}

    problems_votes.each do |vote|
      if round_1_tally[vote.problem_response_id]
        round_1_tally[vote.problem_response_id] = round_1_tally[vote.problem_response_id] + vote.vote_number
      else
        round_1_tally[vote.problem_response_id] = vote.vote_number
      end
    end

    round_1_winners = round_1_tally
    .sort_by { |k, v| v }
    .reverse
    .take(2)

    runoff_tally = {}

    runoff_tally[round_1_winners[0][0]] = 0
    runoff_tally[round_1_winners[1][0]] = 0

    problems_votes
    .group_by { |pv| pv.user_id }
    .each do |user_id, votes|
      vote_map = {}

      votes.each do |vote|
        vote_map[vote.problem_response_id] = vote.vote_number
      end

      if vote_map[round_1_winners[0][0]] > vote_map[round_1_winners[1][0]]
        votes.each do |vote|
          runoff_tally[round_1_winners[0][0]] = runoff_tally[round_1_winners[0][0]] + vote.vote_number
        end
      else
        votes.each do |vote|
          runoff_tally[round_1_winners[1][0]] = runoff_tally[round_1_winners[1][0]] + vote.vote_number
        end
      end
    end

    runoff_winners = runoff_tally
    .sort_by { |k, v| v }
    .reverse

    return {
      round_1_winner: {
        problem_response: ProblemResponse.find(round_1_winners[0][0]),
        tally: round_1_winners[0][1]
      },
      round_1_runner_up: {
        problem_response: ProblemResponse.find(round_1_winners[1][0]),
        tally: round_1_winners[1][1]
      },
      runoff_winner: {
        problem_response: ProblemResponse.find(runoff_winners[0][0]),
        tally: runoff_winners[0][1]
      },
      runoff_runner_up: {
        problem_response: ProblemResponse.find(runoff_winners[1][0]),
        tally: runoff_winners[1][1]
      }
    }
  end
end
