class WorkshopChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    p "SUBSCRIBE"
    p current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    p "UNSUBSCRIBE"
    p current_user
  end
end
