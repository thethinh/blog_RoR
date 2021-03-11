# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "blog_RoR"
set :repo_url, "git@github.com:thethinh/blog_RoR.git"
set :ssh_options, { :forward_agent => true }

set :pty, true
set :linked_files, %w(config/database.yml config/application.yml config/master.key)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)
set :keep_releases, 5
set :rbenv_type, :user

set :puma_rackup, -> {File.join(current_path, "config.ru")}
set :puma_state, -> {"#{shared_path}/tmp/pids/puma.state"}
set :puma_pid, -> {"#{shared_path}/tmp/pids/puma.pid"}
set :puma_bind, -> {"unix://#{shared_path}/tmp/sockets/puma.sock"}
set :puma_conf, -> {"#{shared_path}/puma.rb"}
set :puma_access_log, -> {"#{shared_path}/log/puma_access.log"}
set :puma_error_log, -> {"#{shared_path}/log/puma_error.log"}
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, "production"))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

task :restart, :clear_cache do
  on roles(:app) do
    execute "cd /var/www/blog_RoR/current"
    execute :sudo, :systemctl, :restart, :sidekiq
  end
end