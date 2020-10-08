# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :facebook,
           ENV['FACEBOOK_CLIENT_ID'],
           ENV['FACEBOOK_CLIENT_SECRET'],
           scope: 'public_profile, email'
end
