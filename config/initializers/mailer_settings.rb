if ENV["RAILS_ENV"] == "staging" || ENV["RAILS_ENV"] == "production"
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
end