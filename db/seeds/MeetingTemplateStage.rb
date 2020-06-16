template_stages = {
  BRANCH_1: ["WHATS_WORKING", "PROBLEMS", "REFRAME_PROBLEM", "OPPORTUNITY_QUESTION", "SOLUTIONS", "EXPERIMENT"]
}

template_stages.each do |template_key, stages|
  stages.each do |stage|
    meeting_stage = MeetingStage
    .where(key: stage)
    .first

    MeetingTemplate
    .where(key: template_key)
    .first
    .meeting_template_stages
    .create(
      meeting_stage_id: meeting_stage.id
    )
  end
end

puts "- Meeting Template Stages Created -"