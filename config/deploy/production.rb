set :stage, :production
set :rails_env, :production
set :branch, "master"
set :deploy_to, "/var/www/blog_RoR"
server "18.139.217.68", user: "ubuntu", roles: %w{app db web}
