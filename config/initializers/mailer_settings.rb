ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  address: "smtp.sparkpostmail.com",
  domain: "meetingzero.net",
  port: 587,
  user_name: "SMTP_Injection",
  password: Rails.application.credentials.sparkpost_key,
  authentication: :plain,
  enable_starttls_auto: true
}