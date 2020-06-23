class Api::V1::WorkshopDirectorsController < ApplicationController
  before_action :authenticate_user

  def index
    workshop_directors = Workshop
    .where(workshop_token: params[:workshop_id])
    .first
    .workshop_directors
    .all
    .order(id: :asc)

    return render :json => workshop_directors.group_by { |i| i.workshop_stage_id }, include: [:workshop_stage, :workshop_stage_step]
  end

  def current
    workshop_director = Workshop
    .where(workshop_token: params[:workshop_id])
    .first
    .workshop_directors
    .where(completed: false)
    .order(id: :asc)
    .first

    return render :json => workshop_director, include: [:workshop_stage, :workshop_stage_step]
  end
end
