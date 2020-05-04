class SendNotificationsService
  def initialize(content, id_channel, user_send_email)
    @content = content
    @id_channel = id_channel
    @user_send_email = user_send_email
  end

  def send_notifications
    ActionCable.server.broadcast "notifications_channel_#{@id_channel}",
      content: @content
    NotificationsToEmailJob.perform_later(@user_send_email,@content)
  end
end