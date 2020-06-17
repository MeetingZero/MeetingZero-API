# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def activate_account
    UserMailer.activate_account(User.first)
  end

  def forgot_password
    UserMailer.forgot_password(User.first)
  end
end
