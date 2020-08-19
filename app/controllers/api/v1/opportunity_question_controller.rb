class Api::V1::OpportunityQuestionController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop
  before_action :authorize_user_is_host, except: [:index]

  def index
    opportunity_question_response = OpportunityQuestionResponse.where(
      workshop_id: @workshop.id
    )
    .first

    return render :json => opportunity_question_response
  end

  def create
    opportunity_question_response = OpportunityQuestionResponse
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    return render :json => opportunity_question_response, status: 201
  end

  def update
    OpportunityQuestionResponse
    .find(params[:id])
    .update(response_text: params[:response_text])

    opportunity_question_record = OpportunityQuestionResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    return render :json => opportunity_question_record
  end
end
