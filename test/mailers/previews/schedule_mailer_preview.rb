# Preview all emails at http://localhost:3000/rails/mailers/schedule_mailer
class ScheduleMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/schedule_mailer/auto_sendmail
  def auto_sendmail
    ScheduleMailer.auto_sendmail
  end

end
