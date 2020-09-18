class Api::V1::EmailSubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    email_exists = EmailSubmission
    .where(email: params[:email])
    .exists?

    if email_exists
      return render :json => { error: "Email is already registered" }, status: 400
    end

    EmailSubmission
    .create(email: params[:email])

    return head 201
  end
end
