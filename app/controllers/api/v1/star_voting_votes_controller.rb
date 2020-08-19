require_relative "../../../services/star_voting"

class Api::V1::StarVotingVotesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def create
    if params[:save_exclusive]
      StarVotingVote
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id,
        resource_model_name: params[:resource_model_name]
      )
      .destroy_all
    end

    StarVotingVote.create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      resource_model_name: params[:resource_model_name],
      resource_id: params[:resource_id],
      vote_number: params[:vote_number]
    )

    resource_records = params[:resource_model_name]
    .constantize
    .where(workshop_id: @workshop.id)
    .order(id: :asc)

    resource_records = resource_records.map do |pr|
      pr
      .as_json
      .merge!({
        star_voting_vote: StarVotingVote.where(
          user_id: @current_user.id,
          workshop_id: @workshop.id,
          resource_model_name: params[:resource_model_name],
          resource_id: pr.id
        ).first
      })
    end

    return render :json => resource_records, status: 201
  end

  def update
    StarVotingVote
    .where(
      id: params[:id],
      user_id: @current_user.id,
      workshop_id: @workshop.id,
      resource_model_name: params[:resource_model_name],
      resource_id: params[:resource_id]
    )
    .first
    .update(vote_number: params[:vote_number])

    resource_records = params[:resource_model_name]
    .constantize
    .where(workshop_id: @workshop.id)
    .order(id: :asc)

    resource_records = resource_records.map do |pr|
      pr
      .as_json
      .merge!({
        star_voting_vote: StarVotingVote.where(
          user_id: @current_user.id,
          workshop_id: @workshop.id,
          resource_model_name: params[:resource_model_name],
          resource_id: pr.id
        ).first
      })
    end

    return render :json => resource_records
  end

  def calculate_votes
    star_voting = StarVoting.new(
      @workshop.id,
      params[:resource_model_name]
    )

    render :json => star_voting.calculate_votes
  end
end
