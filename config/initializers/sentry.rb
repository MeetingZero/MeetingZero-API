if Rails.env == "production" || Rails.env == "staging"
  Raven.configure do |config|
    config.dsn = Rails.application.credentials.sentry_dsn
  end
end
