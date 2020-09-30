# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    @conversation = Conversation.includes(:recipient).find(params[:conversation_id])
    @message = @conversation.messages.create(message_params)
    sender = @message.user
    recipient = @message.conversation.opposed_user(sender)

    ActionCable.server.broadcast "room_chat_channel_#{recipient.id}",
                                 message: @message,
                                 sender: sender
    respond_to do |format|
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :body)
  end
end
