class WorkshopRelayChannel < ApplicationCable::Channel
  def subscribed
    stream_from "workshop_relay_#{params[:workshop_token]}"
  end

  def unsubscribed
  end

  def receive(data)
    ActionCable
    .server
    .broadcast("workshop_relay_#{params[:workshop_token]}", data)
  end
end
