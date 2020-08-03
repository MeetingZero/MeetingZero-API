# Development and Staging only
if Rails.env == "development" || Rails.env == "staging"
  require_relative "./seeds/User"
end

require_relative "./seeds/WorkshopStage"
require_relative "./seeds/WorkshopStageStep"
require_relative "./seeds/WorkshopTemplate"
require_relative "./seeds/WorkshopTemplateStage"