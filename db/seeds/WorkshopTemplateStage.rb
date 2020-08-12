template_stages = {
  BRANCH_1: ["WHATS_WORKING", "PROBLEMS", "REFRAME_PROBLEM", "OPPORTUNITY_QUESTION", "SOLUTIONS", "EXPERIMENTS"]
}

template_stages.each do |template_key, stages|
  stages.each do |stage|
    workshop_stage = WorkshopStage
    .where(key: stage)
    .first

    WorkshopTemplate
    .where(key: template_key)
    .first
    .workshop_template_stages
    .create(
      workshop_stage_id: workshop_stage.id
    )
  end
end

puts "- Workshop Template Stages Created -"