if Rails.env == "production" || Rails.env == "staging"
  Raven.configure do |config|
    config.dsn = "https://00b9c02e492644b7b3ceb423c2e38b51@o459140.ingest.sentry.io/5457814"
  end
end