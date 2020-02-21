class ScheduleMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.schedule_mailer.auto_sendmail.subject
  #
  
  def auto_sendmail(user)
    @user = user
    mail to: user.email, subject: "Auto send email"
  end
end
