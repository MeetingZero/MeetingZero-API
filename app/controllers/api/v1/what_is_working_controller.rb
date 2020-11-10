class Api::V1::WhatIsWorkingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop, only: [:index, :create, :update]

  def index
    if params[:my_filter]
      what_is_working_records = WhatIsWorkingResponse
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id
      )
      .order(id: :asc)
    else
      what_is_working_records = WhatIsWorkingResponse
      .where(workshop_id: @workshop.id)
    end

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
    .order(id: :asc)

    return render :json => what_is_working_records, status: 201
  end

  def update
    WhatIsWorkingResponse
    .find(params[:id])
    .update(response_text: params[:response_text])

    what_is_working_records = WhatIsWorkingResponse
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .order(id: :asc)

    return render :json => what_is_working_records
  end
end
