class Api::V1::ExperimentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop
  before_action :authorize_user_is_host, except: [:get_hypothesis, :get_tasks]

  def get_hypothesis
    experiments_hypothesis = ExperimentHypothesis
    .where(
      workshop_id: @workshop.id
    )
    .first

    render :json => experiments_hypothesis
  end

  def save_hypothesis
    experiments_hypothesis = ExperimentHypothesis
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    if experiments_hypothesis
      experiments_hypothesis
      .update(
        we_believe_text: params[:we_believe_text],
        will_result_in_text: params[:will_result_in_text],
        succeeded_when_text: params[:succeeded_when_text]
      )

      experiments_hypothesis_record = ExperimentHypothesis
      .where(
        workshop_id: @workshop.id,
        user_id: @current_user.id
      )
      .first

      return render :json => experiments_hypothesis_record
    else
      experiments_hypothesis_record = ExperimentHypothesis
      .create(
        workshop_id: @workshop.id,
        user_id: @current_user.id,
        we_believe_text: params[:we_believe_text],
        will_result_in_text: params[:will_result_in_text],
        succeeded_when_text: params[:succeeded_when_text]
      )

      return render :json => experiments_hypothesis_record, status: 201
    end
  end

  def get_tasks
    experiment_tasks = ExperimentTask
    .where(
      workshop_id: @workshop.id
    )

    render :json => experiment_tasks, include: [:experiment_task_assignments]
  end

  def save_task
    ExperimentTask
    .create(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      response_text: params[:response_text]
    )

    experiment_tasks = ExperimentTask
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    # Broadcast experiment tasks to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      experiment_tasks: experiment_tasks.as_json(
        include: [:experiment_task_assignments]
      )
    )

    render :json => experiment_tasks, include: [:experiment_task_assignments], status: 201
  end

  def update_task
    experiment_task = ExperimentTask
    .where(
      id: params[:task_id],
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )
    .first

    experiment_task.update(
      response_text: params[:response_text]
    )

    experiment_tasks = ExperimentTask
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id
    )

    # Broadcast experiment tasks to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      experiment_tasks: experiment_tasks.as_json(
        include: [:experiment_task_assignments]
      )
    )

    render :json => experiment_tasks, include: [:experiment_task_assignments]
  end

  def assign_task
    experiment_task_assignment = ExperimentTaskAssignment
    .where(
      workshop_id: @workshop.id,
      experiment_task_id: params[:task_id],
      user_id: params[:user_id]
    )
    .first

    if experiment_task_assignment
      experiment_task_assignment
      .update(assignment_text: params[:assignment_text])
    else
      ExperimentTaskAssignment
      .create(
        workshop_id: @workshop.id,
        experiment_task_id: params[:task_id],
        user_id: params[:user_id],
        assignment_text: params[:assignment_text]
      )
    end

    experiment_tasks = ExperimentTask
    .where(
      workshop_id: @workshop.id
    )

    # Broadcast experiment tasks to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      experiment_tasks: experiment_tasks.as_json(
        include: [:experiment_task_assignments]
      )
    )

    render :json => experiment_tasks, include: [:experiment_task_assignments]
  end
end
