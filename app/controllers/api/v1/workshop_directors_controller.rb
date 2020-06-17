class Api::V1::WorkshopDirectorsController < ApplicationController
  before_action :authenticate_user

  def index
    workshop_directors = Workshop
    .find(params[:workshop_id])
    .workshop_directors
    .all
    .order(id: :asc)

    return render :json => workshop_directors
  end

  def current
    workshop_director = Workshop
    .find(params[:workshop_id])
    .workshop_directors
    .where(completed: false)
    .order(id: :asc)
    .first

    return render :json => workshop_director
  end
end
