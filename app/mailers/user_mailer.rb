class UserMailer < ApplicationMailer
  def activate_account(user)
    @user = user

    mail(to: user.email, subject: "MeetingZero - Activate Account")
  end

  def forgot_password(user)
    @user = user

    mail(to: user.email, subject: "MeetingZero - Password Reset")
  end
end
