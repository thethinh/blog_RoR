require 'test_helper'

class ScheduleMailerTest < ActionMailer::TestCase
  test "auto_sendmail" do
    mail = ScheduleMailer.auto_sendmail
    assert_equal "Auto sendmail", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
