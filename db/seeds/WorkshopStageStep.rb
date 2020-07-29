WorkshopStage
.where(key: "WHATS_WORKING")
.first
.workshop_stage_steps
.create(
  key: "WHATS_WORKING_RESPONSES",
  name: "Responses",
  default_time_limit: 120,
  description: "What's working responses"
)

WorkshopStage
.where(key: "WHATS_WORKING")
.first
.workshop_stage_steps
.create(
  key: "WHATS_WORKING_REVIEW",
  name: "Review",
  default_time_limit: 120,
  description: "What's working review"
)

WorkshopStage
.where(key: "PROBLEMS")
.first
.workshop_stage_steps
.create(
  key: "PROBLEMS_REPONSES",
  name: "Responses",
  default_time_limit: 180,
  description: "Problem responses"
)

WorkshopStage
.where(key: "PROBLEMS")
.first
.workshop_stage_steps
.create(
  key: "PROBLEMS_VOTE",
  name: "Vote",
  default_time_limit: 300,
  description: "Problem voting"
)

WorkshopStage
.where(key: "PROBLEMS")
.first
.workshop_stage_steps
.create(
  key: "PROBLEMS_REVIEW_VOTES",
  name: "Review Votes",
  default_time_limit: 120,
  description: "Review problem votes"
)

puts "- Workshop Stage Steps Created -"
