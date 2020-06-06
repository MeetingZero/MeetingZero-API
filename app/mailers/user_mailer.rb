class UserMailer < ApplicationMailer
  def forgot_password(forgot_password_token)
    @forgot_password_token = forgot_password_token

    mail(to: "arsood@gmail.com", subject: "MeetingZero - Password Reset")
  end
end
