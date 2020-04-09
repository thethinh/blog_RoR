class NotificationsMailer < ApplicationMailer
  def notifications_from_app(user,content)
    @user = user
    @content = content
    mail to: user.email, subject: "Notifications from sample app"
  end
  
end
