class Api::V1::WorkshopStageStepReadyController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user
  before_action :authorize_user_for_workshop

  def index
    ready_members = WorkshopStageStepReady
    .where(
      workshop_id: @workshop.id,
      workshop_director_id: params[:workshop_director_id]
    )

    return render :json => ready_members
  end

  def create
    WorkshopStageStepReady
    .find_or_create_by(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      workshop_director_id: params[:workshop_director_id]
    )

    ready_members = WorkshopStageStepReady
    .where(
      workshop_id: @workshop.id,
      workshop_director_id: params[:workshop_director_id]
    )

    # Broadcast ready members to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      ready_members: ready_members
    )

    return head 201
  end

  def destroy
    ready_member = WorkshopStageStepReady
    .where(
      workshop_id: @workshop.id,
      user_id: @current_user.id,
      workshop_director_id: params[:workshop_director_id]
    )
    .first

    if ready_member
      ready_member.destroy
    end

    ready_members = WorkshopStageStepReady
    .where(
      workshop_id: @workshop.id,
      workshop_director_id: params[:workshop_director_id]
    )

    # Broadcast ready members to the channel
    WorkshopChannel
    .broadcast_to(
      @workshop,
      ready_members: ready_members
    )

    return head 200
  end
end
