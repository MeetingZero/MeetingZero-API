class Api::V1::WhatIsWorkingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop, only: [:create]

  def create
    what_is_working_response = WhatIsWorkingResponse
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    return render :json => what_is_working_response, status: 201
  end
end
