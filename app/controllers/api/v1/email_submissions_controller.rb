class Api::V1::EmailSubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    user_exists = User
    .where(email: params[:email])
    .exists?

    if user_exists
      return render :json => { error: "USER_EXISTS" }, status: 400
    end

    email_exists = EmailSubmission
    .where(email: params[:email])
    .exists?

    if email_exists
      return render :json => { error: "ALREADY_RECORDED" }, status: 400
    end

    EmailSubmission
    .create(email: params[:email])

    return head 201
  end
end
