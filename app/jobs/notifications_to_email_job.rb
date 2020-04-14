class NotificationsToEmailJob < ApplicationJob
  queue_as :default

  def perform(user, content)
    NotificationsMailer.notifications_from_app(user, content).deliver_now
  end
end
