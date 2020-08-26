class StarVoting
  def initialize(workshop_id, resource_model_name)
    @workshop_id = workshop_id
    @resource_model_name = resource_model_name
  end

  def calculate_votes
    star_voting_result = StarVotingResult
    .where(
      resource_model_name: @resource_model_name,
      workshop_id: @workshop_id
    )
    .first

    # If results were previously calculated, just return the results
    if star_voting_result
      return create_payload(star_voting_result)
    end

    resource_records = @resource_model_name
    .constantize
    .where(workshop_id: @workshop_id)

    # If there is only one record, don't bother calculating votes
    # This is useful since the front end will trigger immediate calculation of votes if there is only one record
    if resource_records.length === 1
      new_star_voting_result = StarVotingResult
      .create(
        workshop_id: @workshop_id,
        resource_model_name: @resource_model_name,
        runoff_winner_resource_id: resource_records.first.id,
        runoff_winner_tally: 5
      )

      return create_payload(new_star_voting_result)
    end

    resource_votes = StarVotingVote
    .where(
      workshop_id: @workshop_id,
      resource_model_name: @resource_model_name
    )

    # If there is just 1 vote then it wins
    if resource_votes.length == 1
      winning_resource_vote = resource_votes.first

      new_star_voting_result = StarVotingResult
      .create(
        workshop_id: @workshop_id,
        resource_model_name: @resource_model_name,
        runoff_winner_resource_id: winning_resource_vote.resource_id,
        runoff_winner_tally: winning_resource_vote.vote_number
      )

      return create_payload(new_star_voting_result)
    end

    round_1_tally = {}

    # Build tally of sum of votes matched to resource_id's
    resource_votes.each do |vote|
      if round_1_tally[vote.resource_id]
        round_1_tally[vote.resource_id] = round_1_tally[vote.resource_id] + vote.vote_number
      else
        round_1_tally[vote.resource_id] = vote.vote_number
      end
    end

    # Sort by descending order and then take the top two highest items
    round_1_winners = round_1_tally
    .sort_by { |k, v| v }
    .reverse
    .take(2)

    # TODO: If the two from the above array are equal, then trigger tie

    runoff_tally = {}

    runoff_tally[round_1_winners[0][0]] = 0
    runoff_tally[round_1_winners[1][0]] = 0

    # Group votes by user ID
    resource_votes
    .group_by { |pv| pv.user_id }
    .each do |user_id, votes|
      vote_map = {}

      # Build vote map to easily look up vote_number for any user's resource_id
      votes.each do |vote|
        vote_map[vote.resource_id] = vote.vote_number
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

    new_star_voting_result = StarVotingResult
    .create(
      workshop_id: @workshop_id,
      resource_model_name: @resource_model_name,
      round_1_runner_up_resource_id: round_1_winners[1][0],
      round_1_runner_up_tally: round_1_winners[1][1],
      round_1_winner_resource_id: round_1_winners[0][0],
      round_1_winner_tally: round_1_winners[0][1],
      runoff_runner_up_resource_id: runoff_winners[1][0],
      runoff_runner_up_tally: runoff_winners[1][1],
      runoff_winner_resource_id: runoff_winners[0][0],
      runoff_winner_tally: runoff_winners[0][1]
    )

    return create_payload(new_star_voting_result)
  end

  def create_payload(star_voting_result)
    payload = {}

    if star_voting_result.round_1_winner_resource_id && star_voting_result.round_1_winner_tally
      payload[:round_1_winner] = {
        resource: star_voting_result.resource_model_name.constantize.find(star_voting_result.round_1_winner_resource_id),
        tally: star_voting_result.round_1_winner_tally
      }
    end

    if star_voting_result.round_1_runner_up_resource_id && star_voting_result.round_1_runner_up_tally
      payload[:round_1_runner_up] = {
        resource: star_voting_result.resource_model_name.constantize.find(star_voting_result.round_1_runner_up_resource_id),
        tally: star_voting_result.round_1_runner_up_tally
      }
    end

    if star_voting_result.runoff_winner_resource_id && star_voting_result.runoff_winner_tally
      payload[:runoff_winner] = {
        resource: star_voting_result.resource_model_name.constantize.find(star_voting_result.runoff_winner_resource_id),
        tally: star_voting_result.runoff_winner_tally
      }
    end

    if star_voting_result.runoff_runner_up_resource_id && star_voting_result.runoff_runner_up_tally
      payload[:runoff_runner_up] = {
        resource: star_voting_result.resource_model_name.constantize.find(star_voting_result.runoff_runner_up_resource_id),
        tally: star_voting_result.runoff_runner_up_tally
      }
    end

    return payload
  end
end
