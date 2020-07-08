class Api::V1::WhatIsWorkingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop, only: [:index, :create]

  def index
    what_is_working_records = WhatIsWorkingResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    return render :json => what_is_working_records
  end

  def create
    what_is_working_response = WhatIsWorkingResponse
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    what_is_working_records = WhatIsWorkingResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    return render :json => what_is_working_records, status: 201
  end
end
