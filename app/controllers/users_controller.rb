class UsersController < ApplicationController
  def activate_account
    user = User
    .where(email: params[:email], account_activation_token: params[:token])
    .first

    if !user
      return render :text => "No user found"
    end

    user.update_attributes(account_activation_token: nil)

    return redirect_to "#{Rails.application.credentials.web_app_url}/login?account_activated=true"
  end
end
