# frozen_string_literal: true

# config valid only for current version of Capistrano lock '3.6.1'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/sidekiq.yml', 'config/rev-manifest.json'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'bundle', 'public/uploads', 'public/assets'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
set :local_user, 'minh'
set :use_sudo, false

namespace :deploy do
  desc 'Upload yml file.'
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/config/puma"
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
      upload!('config/sidekiq.yml', "#{shared_path}/config/sidekiq.yml")
      upload!('config/puma/buildcauhinh.com.rb', "#{shared_path}/config/puma/buildcauhinh.com.rb")
    end
  end
  before 'deploy:check', 'deploy:upload_yml'

  desc 'Prepare assets'
  task :prepare_assets do
    run_locally do
      execute "cd frontend && gulp --#{fetch(:stage)} && gulp rev"
    end

    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/public/assets"
      execute "rm -rf #{shared_path}/public/assets/*"
      upload!('config/rev-manifest.json', "#{shared_path}/config/rev-manifest.json")
      upload!('public/assets', "#{shared_path}/public/", recursive: true)
    end
  end

  desc 'Run migrations'
  task :migrate do
    on roles(:app) do
      db_url = "postgres://localhost/buildcauhinh_production?user=$BUILDCAUHINH_DATABASE_USERNAME&password=$BUILDCAUHINH_DATABASE_PASSWORD"
      execute("cd '#{current_path}' && #{fetch(:rbenv_prefix)} bundle exec sequel -m #{current_path}/db/migrations \"#{db_url}\"")
    end
  end
  before 'deploy:publishing', 'deploy:migrate'
end
