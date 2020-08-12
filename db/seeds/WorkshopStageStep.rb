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

WorkshopStage
.where(key: "REFRAME_PROBLEM")
.first
.workshop_stage_steps
.create(
  key: "REFRAME_PROBLEM_RESPONSE",
  name: "Responses",
  default_time_limit: 300,
  description: "Reframe problem responses"
)

WorkshopStage
.where(key: "REFRAME_PROBLEM")
.first
.workshop_stage_steps
.create(
  key: "REFRAME_PROBLEM_VOTE",
  name: "Vote",
  default_time_limit: 240,
  description: "Reframe problem votes"
)

WorkshopStage
.where(key: "REFRAME_PROBLEM")
.first
.workshop_stage_steps
.create(
  key: "REFRAME_PROBLEM_REVIEW_VOTES",
  name: "Review Votes",
  default_time_limit: 120,
  description: "Reframe problem review votes"
)

WorkshopStage
.where(key: "OPPORTUNITY_QUESTION")
.first
.workshop_stage_steps
.create(
  key: "OPPORTUNITY_QUESTION_RESPONSE",
  name: "Response",
  default_time_limit: 120,
  description: "Opportunity question response",
  discussion_allowed: true
)

WorkshopStage
.where(key: "SOLUTIONS")
.first
.workshop_stage_steps
.create(
  key: "SOLUTIONS_RESPONSES",
  name: "Responses",
  default_time_limit: 300,
  description: "Solutions responses"
)

WorkshopStage
.where(key: "SOLUTIONS")
.first
.workshop_stage_steps
.create(
  key: "SOLUTIONS_IMPACT_EFFORT",
  name: "Impact/Effort",
  default_time_limit: 300,
  description: "Solutions impact and effort"
)

WorkshopStage
.where(key: "EXPERIMENTS")
.first
.workshop_stage_steps
.create(
  key: "EXPERIMENTS_HYPOTHESIS",
  name: "Hypothesis",
  default_time_limit: 300,
  description: "Experiments hypothesis",
  discussion_allowed: true
)

WorkshopStage
.where(key: "EXPERIMENTS")
.first
.workshop_stage_steps
.create(
  key: "EXPERIMENTS_OWNERS",
  name: "Owner(s)",
  default_time_limit: 10000,
  description: "Experiments owners",
  discussion_allowed: true
)

puts "- Workshop Stage Steps Created -"
