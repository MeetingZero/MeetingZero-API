if Rails.env == "production" || Rails.env == "staging"
  Raven.configure do |config|
    config.dsn = "https://93b687fb7ead48d1ad6a5402823bc71b@o459140.ingest.sentry.io/5457845"
  end
end