# frozen_string_literal: true

class ConversationChannel < ApplicationCable::Channel
  include SessionsHelper

  def subscribed
    stream_from "room_chat_channel_#{current_user.id}" if logged_in?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
