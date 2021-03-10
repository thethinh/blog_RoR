set :stage, :production
set :rails_env, :production
set :branch, "master"
set :deploy_to, "var/www/blog_RoR"
server "52.221.235.8", user: "ubuntu", roles: %w{app db web}
