class Api::V1::WorkshopDirectorsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def index
    workshop_directors = WorkshopDirector
    .get_ordered(params[:workshop_id])

    return render :json => workshop_directors.group_by { |i| i.workshop_stage_id }, include: [:workshop_stage, :workshop_stage_step]
  end

  def current
    workshop_director = WorkshopDirector
    .get_current(params[:workshop_id])

    return render :json => workshop_director, include: [:workshop_stage, :workshop_stage_step]
  end

  def add_time_to_current
    seconds_to_add = params[:seconds_to_add].to_i

    current_workshop_director = WorkshopDirector
    .get_current(params[:workshop_id])

    # Generate an expire time from UTC + number of seconds given to this new stage step
    expire_time = Time.now.utc + seconds_to_add.seconds

    # New director stage step gets an time expiration
    current_workshop_director
    .update(
      workshop_stage_step_expire_time: expire_time.to_time.iso8601
    )

    # Broadcast updated director to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      current_workshop_director: current_workshop_director.as_json(include: [:workshop_stage, :workshop_stage_step])
    )

    head 200
  end
end
