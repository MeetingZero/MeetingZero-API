class WorkshopChannel < ApplicationCable::Channel
  def subscribed
    stream_from params[:workshop_token]

    workshop = Workshop
    .where(workshop_token: params[:workshop_token])
    .first
    
    WorkshopMember
    .where(
      user_id: current_user.id,
      workshop_id: workshop.id
    )
    .first
    .update(online: true)
  end

  def unsubscribed
    workshop = Workshop
    .where(workshop_token: params[:workshop_token])
    .first
    
    WorkshopMember
    .where(
      user_id: current_user.id,
      workshop_id: workshop.id
    )
    .first
    .update(online: false)
  end
end
