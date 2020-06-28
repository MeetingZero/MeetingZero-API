class WorkshopChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    p current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
