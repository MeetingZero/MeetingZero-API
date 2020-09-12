class Api::V1::WorkshopsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, except: [:validate]
  before_action :authorize_user_for_workshop, only: [:show, :members, :start_workshop, :complete_step, :summary]
  before_action :authorize_user_is_host, only: [:start_workshop, :complete_step]

  def index
    render :json => WorkshopMember
    .where(user_id: @current_user.id)
    .as_json(include: [:workshop])
  end
  
  def create
    ActiveRecord::Base.transaction do
      begin
        new_workshop = Workshop.create(
          host_id: @current_user.id,
          purpose: params[:purpose],
          date_time_planned: params[:date_time_planned]
        )

        workshop_stage_keys = []

        if params[:template]
          template = WorkshopTemplate
          .where(key: params[:template])
          .first

          template_stages = WorkshopTemplateStage
          .where(workshop_template_id: template.id)

          template_stages.each do |template_stage|
            workshop_stage = WorkshopStage.find(template_stage.workshop_stage_id)

            workshop_stage_keys.push(workshop_stage.key)
          end
        else
          workshop_stage_keys = params[:workshop_stage_keys]
        end

        workshop_stage_keys.each do |workshop_stage_key|
          workshop_stage = WorkshopStage
          .where(key: workshop_stage_key)
          .first

          WorkshopStageStep
          .where(workshop_stage_id: workshop_stage.id)
          .each do |workshop_stage_step|
            WorkshopDirector
            .create(
              workshop_id: new_workshop.id,
              workshop_stage_id: workshop_stage.id,
              workshop_stage_step_id: workshop_stage_step.id
            )
          end
        end

        emails = params[:emails]

        emails.each do |email|
          user = User
          .where(email: email)
          .first

          if user
            WorkshopMember
            .create(
              workshop_id: new_workshop.id,
              user_id: user.id
            )

            WorkshopMailer
            .join_workshop(user, @current_user, new_workshop)
            .deliver_later
          else
            WorkshopMember
            .create(
              workshop_id: new_workshop.id,
              email: email
            )

            WorkshopMailer
            .join_workshop_new_user(email, @current_user, new_workshop)
            .deliver_later
          end
        end

        # Add host to member list
        WorkshopMember
        .create(
          workshop_id: new_workshop.id,
          user_id: @current_user.id
        )

        return render :json => new_workshop, status: 201
      rescue
        render :json => { error: ["could not create workshop"] }, status: 400
        raise ActiveRecord::Rollback
      end
    end
  end

  def show
    workshop = Workshop
    .where(workshop_token: params[:id])
    .first
    .as_json

    if @current_user.id == workshop["host_id"]
      workshop.merge!({ is_host: true })
    else
      workshop.merge!({ is_host: false })
    end

    return render :json => workshop
  end

  def members
    workshop_members = WorkshopMember
    .where(
      workshop_id: @workshop.id
    )

    render :json => workshop_members
    .to_json(
      include: {
        user: {
          only: [:first_name, :last_name]
        }
      }
    )
  end

  def start_workshop
    ActiveRecord::Base.transaction do
      begin
        current_workshop_director = WorkshopDirector
        .get_current(params[:workshop_id])

        current_stage_step = WorkshopStageStep
        .find(current_workshop_director.workshop_stage_step_id)

        stage_step_time_limit = current_stage_step.default_time_limit

        # Generate an expire time from UTC + number of seconds given to this stage step
        expire_time = Time.now.utc + stage_step_time_limit.seconds

        # Current director stage step gets an time expiration
        current_workshop_director
        .update(
          workshop_stage_step_start_time: Time.now.utc.to_time.iso8601,
          workshop_stage_step_expire_time: expire_time.to_time.iso8601
        )

        workshop = Workshop
        .find_by_token(params[:workshop_id])

        # Add time that workshop started
        workshop.update(started_at: Time.now.utc)

        # Broadcast updated workshop to the channel
        WorkshopChannel
        .broadcast_to(
          workshop,
          workshop: workshop
        )

        return head 200
      rescue
        render :json => { error: ["could not start workshop"] }, status: 400
        raise ActiveRecord::Rollback
      end
    end
  end

  def validate
    workshop = Workshop
    .find_by_token(params[:workshop_id])

    if !workshop
      return render :json => { error: ["could not find workshop"] }, status: 404
    end

    signed_up_user = User
    .where(email: params[:email])
    .first

    if !signed_up_user || signed_up_user.id != params[:user_id].to_i
      return render :json => { error: ["member account cannot be found"] }, status: 400
    end

    workshop_member_email_signup = WorkshopMember
    .where(workshop_id: workshop.id, email: params[:email], user_id: nil)
    .first

    if workshop_member_email_signup
      workshop_member_email_signup
      .update(user_id: signed_up_user.id)
    end

    return head 200
  end

  def complete_step
    workshop = Workshop
    .find_by_token(params[:workshop_id])

    old_workshop_director = WorkshopDirector
    .get_current(params[:workshop_id])

    # If this step has already been completed, short circuit
    # This happens at the end of the workshop
    if old_workshop_director.completed == true
      workshop_members = WorkshopMember
      .where(
        workshop_id: @workshop.id
      )

      # Send all of the members the feedback form via email
      workshop_members.each do |member|
        user = User
        .where(id: member.user_id)
        .first

        if user
          WorkshopMailer
          .request_feedback(
            user,
            workshop
          )
          .deliver_later
        end
      end

      return render :json => { workshop_complete: true }
    end

    old_workshop_director.update(completed: true)

    new_workshop_director = WorkshopDirector
    .get_current(params[:workshop_id])

    current_stage_step = WorkshopStageStep
    .find(new_workshop_director.workshop_stage_step_id)

    stage_step_time_limit = current_stage_step.default_time_limit

    # Generate an expire time from UTC + number of seconds given to this new stage step
    expire_time = Time.now.utc + stage_step_time_limit.seconds

    # New director stage step gets an time expiration
    new_workshop_director
    .update(
      workshop_stage_step_start_time: Time.now.utc.to_time.iso8601,
      workshop_stage_step_expire_time: expire_time.to_time.iso8601
    )

    # Broadcast updated director to the channel
    WorkshopChannel
    .broadcast_to(
      workshop,
      current_workshop_director: new_workshop_director.as_json(include: [:workshop_stage, :workshop_stage_step])
    )

    return head 200
  end

  def summary
    workshop_summary = Workshop.get_summary(@workshop.id)

    return render :json => workshop_summary
  end
end
