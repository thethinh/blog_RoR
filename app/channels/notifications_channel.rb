class NotificationsChannel < ApplicationCable::Channel
  include SessionsHelper

  def subscribed
    if logged_in?
      stream_from "notifications_channel_#{current_user.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
