class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :login]

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

      render :json => { token: token }, status: 201
    else
      render :json => new_user.errors, status: 400
    end
  end

  def login
    user = User
    .where(email: params[:email])
    .first

    if !user
      head 401
    else
      authenticated = user.authenticate(params[:password])

      if !authenticated
        head 401
      else
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

        render :json => { token: token }, status: 200
      end
    end
  end

  def user_params
    params
    .require(:user)
    .permit(:first_name, :last_name, :email, :password, :confirm_password)
  end
end
