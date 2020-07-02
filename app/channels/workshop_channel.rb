class WorkshopChannel < ApplicationCable::Channel
  def subscribed
    workshop = Workshop
    .where(workshop_token: params[:workshop_token])
    .first

    stream_for workshop
    
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
