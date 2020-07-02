class Api::V1::WorkshopDirectorsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user

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
end
