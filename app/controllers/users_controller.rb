class UsersController < ApplicationController
  def activate_account
    user = User
    .where(email: params[:email])
    .first

    if !user
      return render :plain => "No user found"
    end

    if user.account_activation_token == nil
      return redirect_to "#{Rails.application.credentials.web_app_url}/login?already_activated=true"
    end

    if user.account_activation_token != params[:token]
      return render :plain => "Invalid account activation token"
    end

    user.update(account_activation_token: nil)

    return redirect_to "#{Rails.application.credentials.web_app_url}/login?account_activated=true"
  end
end
