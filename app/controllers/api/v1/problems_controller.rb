class Api::V1::ProblemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop, only: [:index, :create, :update]

  def index
    if params[:my_filter]
      problems_records = ProblemResponse
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id
      )
    else
      problems_records = ProblemResponse
      .where(workshop_id: @workshop.id)
    end

    return render :json => problems_records
  end

  def create
    problems_response = ProblemResponse
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    problems_records = ProblemResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    return render :json => problems_records, status: 201
  end

  def update
    ProblemResponse
    .find(params[:id])
    .update(response_text: params[:response_text])

    problems_records = ProblemResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    return render :json => problems_records
  end
end
