class ApplicationController < ActionController::Base
  def authenticate_user
    auth_token = request.headers["Authorization"]
    
    if !auth_token
      return render :json => { auth_token: ["not found"] }, status: 401
    end

    decoded_token = JWT.decode(auth_token, Rails.application.credentials.jwt_secret, true, { algorith: 'HS256' })

    if !decoded_token
      return render :json => { auth_token: ["invalid"] }, status: 401
    end

    @current_user = User.find(decoded_token[0]["id"])
  end
end
