# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  include SessionsHelper

  def subscribed
    stream_from "notifications_channel_#{current_user.id}" if logged_in?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
