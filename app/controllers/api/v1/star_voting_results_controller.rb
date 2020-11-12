class Api::V1::StarVotingResultsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def create
    new_star_voting_result = StarVotingResult
    .find_or_create_by(
      workshop_id: @workshop.id,
      resource_model_name: params[:resource_model_name],
      round_1_runner_up_resource_id: params[:round_1_runner_up_resource_id],
      round_1_runner_up_tally: params[:round_1_runner_up_tally],
      round_1_winner_resource_id: params[:round_1_winner_resource_id],
      round_1_winner_tally: params[:round_1_winner_tally],
      runoff_runner_up_resource_id: params[:runoff_runner_up_resource_id],
      runoff_runner_up_tally: params[:runoff_runner_up_tally],
      runoff_winner_resource_id: params[:runoff_winner_resource_id],
      runoff_winner_tally: params[:runoff_winner_tally]
    )

    render :json => new_star_voting_result, status: 201
  end
end
