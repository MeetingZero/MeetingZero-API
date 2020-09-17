class Api::V1::ReframeProblemController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def index
    if params[:my_filter]
      reframe_problem_records = ReframeProblemResponse
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id
      )
      .first
    elsif params[:voting]
      original_problem_record = ReframeProblemResponse
      .where(workshop_id: @workshop.id)
      .where("meta_data->>'original_problem' = ?", "true")
      .first

      if !original_problem_record
        winning_problem_result = StarVotingResult
        .where(
          workshop_id: @workshop.id,
          resource_model_name: "ProblemResponse"
        )
        .first

        if winning_problem_result && winning_problem_result.runoff_winner_resource_id
          winning_problem_response = ProblemResponse
          .find(winning_problem_result.runoff_winner_resource_id)

          new_reframe_problem_response = ReframeProblemResponse
          .create(
            workshop_id: @workshop.id,
            user_id: winning_problem_response.user_id,
            response_text: winning_problem_response.response_text,
            meta_data: {
              original_problem: true,
              problem_response_id: winning_problem_response.id
            }
          )
        end
      end

      reframe_problem_records = ReframeProblemResponse
      .where(workshop_id: @workshop.id)

      reframe_problem_records = reframe_problem_records.map do |rp|
        rp
        .as_json
        .merge!({
          star_voting_vote: StarVotingVote.where(
            user_id: @current_user.id,
            workshop_id: @workshop.id,
            resource_model_name: "ReframeProblemResponse",
            resource_id: rp.id
          ).first
        })
      end
    else
      reframe_problem_records = ReframeProblemResponse
      .where(workshop_id: @workshop.id)

      reframe_problem_records = reframe_problem_records.map do |rp|
        rp
        .as_json
        .merge!({
          star_voting_vote: StarVotingVote.where(
            user_id: @current_user.id,
            workshop_id: @workshop.id,
            resource_model_name: "ReframeProblemResponse",
            resource_id: rp.id
          ).first
        })
      end
    end

    return render :json => reframe_problem_records
  end

  def create
    reframe_problem_response = ReframeProblemResponse
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    return render :json => reframe_problem_response, status: 201
  end

  def update
    ReframeProblemResponse
    .find(params[:id])
    .update(response_text: params[:response_text])

    reframe_problem_record = ReframeProblemResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    return render :json => reframe_problem_record
  end
end
