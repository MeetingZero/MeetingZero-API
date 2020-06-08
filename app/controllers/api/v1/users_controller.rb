class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:me]

  def create
    new_user = User.create(user_params)

    if new_user.valid?
      token = JWT.encode(
        {
          id: new_user.id,
          first_name: new_user.first_name,
          last_name: new_user.last_name,
          email: new_user.email
        },
        Rails.application.credentials.jwt_secret,
        'HS256'
      )

      return render :json => { token: token }, status: 201
    else
      return render :json => new_user.errors, status: 400
    end
  end

  def login
    user = User
    .where(email: params[:email])
    .first

    if !user
      return render :json => { user: ["is not found"] }, status: 401
    else
      authenticated = user.authenticate(params[:password])

      if !authenticated
        return render :json => { user: ["is not found"] }, status: 401
      else
        if user.account_activation_token
          return render :json => { user: ["is not verified"] }, status: 401
        end

        token = JWT.encode(
          {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          },
          Rails.application.credentials.jwt_secret,
          'HS256'
        )

        return render :json => { token: token }, status: 200
      end
    end
  end

  def me
    render :json => {
      first_name: @current_user.first_name,
      last_name: @current_user.last_name,
      email: @current_user.email
    }
  end

  def forgot_password
    user = User
    .where(email: params[:email])
    .first

    if !user
      return render :json => { email: ["not found"] }, status: 404
    end

    user.password_reset_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)

      break random_token unless User.exists?(password_reset_token: random_token)
    end

    user.save

    UserMailer
    .forgot_password(user)
    .deliver_now

    head 201
  end

  def reset_password
    user = User
    .where(email: params[:email], password_reset_token: params[:token])
    .first

    if !user
      return render :json => { email: ["not found"] }, status: 404
    end

    if params[:password] != params[:confirm_password]
      return render :json => { passwords: ["do not match"] }, status: 400
    end

    user.update(password: params[:password], password_reset_token: nil)

    head 200
  end

  private

  def user_params
    params
    .require(:user)
    .permit(:first_name, :last_name, :email, :password)
  end
end
