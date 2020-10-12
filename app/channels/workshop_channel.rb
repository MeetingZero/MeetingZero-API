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

    workshop_director = WorkshopDirector
    .get_current(workshop.workshop_token)

    # Broadcast current director to the channel
    WorkshopChannel
    .broadcast_to(
      workshop,
      current_workshop_director: workshop_director.as_json(include: [:workshop_stage, :workshop_stage_step])
    )
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
