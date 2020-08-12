class Api::V1::ExperimentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def get_hypothesis
    experiments_hypothesis = ExperimentHypothesis
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    render :json => experiments_hypothesis
  end

  def save_hypothesis
    experiments_hypothesis = ExperimentHypothesis
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    if experiments_hypothesis
      experiments_hypothesis
      .update(
        we_believe_text: params[:we_believe_text],
        will_result_in_text: params[:will_result_in_text],
        succeeded_when_text: params[:succeeded_when_text]
      )

      experiments_hypothesis_record = ExperimentHypothesis
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id
      )
      .first

      return render :json => experiments_hypothesis_record
    else
      experiments_hypothesis_record = ExperimentHypothesis
      .create(
        workshop_id: @workshop.id,
        user_id: @current_user.id,
        we_believe_text: params[:we_believe_text],
        will_result_in_text: params[:will_result_in_text],
        succeeded_when_text: params[:succeeded_when_text]
      )

      return render :json => experiments_hypothesis_record, status: 201
    end
  end
end
