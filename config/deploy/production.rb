set :stage, :production
set :rails_env, :production
set :branch, "master"
set :deploy_to, "var/www/blog_RoR"
server "52.77.236.25", user: "deploy", roles: %w{app db web}
