if ENV["RAILS_ENV"] == "staging" || ENV["RAILS_ENV"] == "production"
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    address: "smtp.sendgrid.net",
    domain: "meetingzero.net",
    port: 465,
    user_name: "apikey",
    password: Rails.application.credentials.sendgrid_key,
    authentication: :ssl,
    enable_starttls_auto: true
  }
end
