# Test one per minute, send mail to user
# every 1.minutes do
#     rake "send_email:auto_sendemail"
# end


every :sunday, at: '11:59pm' do
    rake "send_email:auto_sendemail"
end