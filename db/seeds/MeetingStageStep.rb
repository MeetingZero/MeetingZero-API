MeetingStage
.where(key: "WHATS_WORKING")
.first
.meeting_stage_steps
.create(
  key: "WHATS_WORKING_RESPONSES",
  name: "Responses",
  default_time_limit: 300,
  description: "What's working responses"
)

MeetingStage
.where(key: "PROBLEMS")
.first
.meeting_stage_steps
.create(
  key: "PROBLEMS_REPONSES",
  name: "Responses",
  default_time_limit: 300,
  description: "Problem responses"
)

MeetingStage
.where(key: "PROBLEMS")
.first
.meeting_stage_steps
.create(
  key: "PROBLEMS_VOTE",
  name: "Vote",
  default_time_limit: 300,
  description: "Problem voting"
)

puts "- Meeting Stage Steps Created -"