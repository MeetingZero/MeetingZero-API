class Workshop < ApplicationRecord
  has_many :workshop_directors, dependent: :destroy
  has_many :workshop_members, dependent: :destroy
  has_many :what_is_working_responses, dependent: :destroy
  has_many :problem_responses, dependent: :destroy
  has_many :problem_votes, dependent: :destroy
  has_many :solution_response_priorities, dependent: :destroy
  has_many :experiment_tasks, dependent: :destroy
  has_many :workshop_stage_step_readies, dependent: :destroy
  
  before_create :generate_workshop_token

  def generate_workshop_token
    self.workshop_token = loop do
      random_token = SecureRandom.hex(5)

      break random_token unless Workshop.exists?(workshop_token: random_token)
    end
  end

  def self.find_by_token(workshop_token)
    return Workshop
    .where(workshop_token: workshop_token)
    .first
  end

  def self.get_summary(workshop_id)
    payload = {}

    workshop_directors = WorkshopDirector
    .where(workshop_id: workshop_id)

    workshop_directors = workshop_directors.uniq { |wd| wd.workshop_stage_id }

    workshop_directors.each do |wd|
      workshop_stage_key = WorkshopStage
      .find(wd.workshop_stage_id)
      .key

      if Workshop.methods.include? workshop_stage_key.to_sym
        section_payload = Workshop
        .method(workshop_stage_key.to_sym)
        .call(workshop_id)

        payload.merge! section_payload
      end
    end

    return payload
  end

  def self.WHATS_WORKING(workshop_id)
    payload = {}

    what_is_working_responses = WhatIsWorkingResponse
    .where(workshop_id: workshop_id)

    payload[:what_is_working_responses] = what_is_working_responses

    return payload
  end

  def self.PROBLEMS(workshop_id)
    payload = {}

    problem_responses = ProblemResponse
    .where(workshop_id: workshop_id)

    payload[:problem_responses] = problem_responses

    winning_problem_response_voting_result = StarVotingResult
    .where(
      workshop_id: workshop_id,
      resource_model_name: "ProblemResponse"
    )
    .first

    if winning_problem_response_voting_result && winning_problem_response_voting_result.runoff_winner_resource_id
      payload[:winning_problem] = ProblemResponse.find(winning_problem_response_voting_result.runoff_winner_resource_id)
    end

    return payload
  end

  def self.REFRAME_PROBLEM(workshop_id)
    payload = {}

    reframe_problem_responses = ReframeProblemResponse
    .where(workshop_id: workshop_id)

    payload[:reframe_problem_responses] = reframe_problem_responses

    winning_reframed_problem_voting_result = StarVotingResult
    .where(
      workshop_id: workshop_id,
      resource_model_name: "ReframeProblemResponse"
    )
    .first

    if winning_reframed_problem_voting_result && winning_reframed_problem_voting_result.runoff_winner_resource_id
      payload[:winning_reframed_problem] = ReframeProblemResponse.find(winning_reframed_problem_voting_result.runoff_winner_resource_id)
    end

    return payload
  end

  def self.OPPORTUNITY_QUESTION(workshop_id)
    payload = {}

    opportunity_question_response = OpportunityQuestionResponse
    .where(workshop_id: workshop_id)
    .first

    if opportunity_question_response
      payload[:opportunity_question] = opportunity_question_response
    end

    return payload
  end
  
  def self.SOLUTIONS(workshop_id)
    payload = {}

    solution_responses = SolutionResponse
    .where(workshop_id: workshop_id)
    .as_json(include: [:solution_response_priorities])

    payload[:solution_responses] = solution_responses

    winning_solution_voting_result = StarVotingResult
    .where(
      workshop_id: workshop_id,
      resource_model_name: "SolutionResponse"
    )
    .first

    if winning_solution_voting_result && winning_solution_voting_result.runoff_winner_resource_id
      payload[:winning_solution] = SolutionResponse.find(winning_solution_voting_result.runoff_winner_resource_id)
    end

    return payload
  end

  def self.EXPERIMENTS(workshop_id)
    payload = {}

    experiment_hypothesis = ExperimentHypothesis
    .where(workshop_id: workshop_id)
    .first

    if experiment_hypothesis
      payload[:experiment_hypothesis] = experiment_hypothesis
    end

    experiment_tasks = ExperimentTask
    .where(
      workshop_id: workshop_id
    )
    .as_json(include: [:experiment_task_assignments])

    payload[:experiment_tasks] = experiment_tasks

    return payload
  end
end
