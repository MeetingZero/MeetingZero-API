class ApplicationController < ActionController::Base
  def authenticate_user
    auth_token = request.headers["Authorization"]
    
    if !auth_token
      return render :json => { auth_token: ["not found"] }, status: 401
    end

    decoded_token = JWT.decode(
      auth_token,
      Rails.application.credentials.jwt_secret,
      true,
      { algorithm: 'HS256' }
    )

    if !decoded_token
      return render :json => { auth_token: ["invalid"] }, status: 401
    end

    @current_user = User.find(decoded_token[0]["id"])
  end

  def authorize_user_for_workshop
    if params[:workshop_id]
      workshop_id = params[:workshop_id]
    else
      workshop_id = params[:id]
    end

    @workshop = Workshop
    .where(workshop_token: workshop_id)
    .first

    workshop_member = WorkshopMember
    .where(
      user_id: @current_user.id,
      workshop_id: workshop.id
    )
    .first

    if !workshop_member
      return render :json => { error: ["user is not part of this workshop"] }, status: 401
    end
  end

  def authorize_user_is_host
    if params[:workshop_id]
      workshop_id = params[:workshop_id]
    else
      workshop_id = params[:id]
    end

    workshop = Workshop
    .where(workshop_token: workshop_id)
    .first

    if workshop.host_id != @current_user.id
      return render :json => { error: ["user is not the host"] }, status: 401
    end
  end
end
