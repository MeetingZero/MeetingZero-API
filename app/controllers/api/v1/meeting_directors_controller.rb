class Api::V1::MeetingDirectorsController < ApplicationController
  before_action :authenticate_user

  def index
    meeting_directors = Meeting
    .find(params[:meeting_id])
    .meeting_directors
    .all
    .order(id: :asc)

    return render :json => meeting_directors
  end

  def current
    meeting_director = Meeting
    .find(params[:meeting_id])
    .meeting_directors
    .where(completed: false)
    .order(id: :asc)
    .first

    return render :json => meeting_director
  end
end
