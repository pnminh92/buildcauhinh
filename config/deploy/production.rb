# frozen_string_literal: true

set :stage, :production
server '172.104.64.43', user: 'buildcauhinh', roles: %w[app web]

set :application, 'buildcauhinh.com'
set :repo_url, 'git@bitbucket.org:wofiminh/timgialinhkien.git'

# Default branch is :master
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/buildcauhinh.com/public_html'

# capistrano-rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.4.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails puma pumactl sidekiq sidekiqctl]
set :rbenv_roles, :all # default value

# capistrano/bundler
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_path, -> { shared_path.join('bundle') }
set :bundle_without, %w[development test].join(' ')
set :bundle_jobs, 4
set :bundle_flags, '--deployment --quiet'

# capistrano/puma
set :puma_user, fetch(:user)
set :puma_conf, -> { "#{shared_path}/config/puma/buildcauhinh.com.rb" }
set :puma_role, :web

# capistrano/sidekiq
 set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
 set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
 set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
 set :sidekiq_config, File.join(shared_path, 'config', 'sidekiq.yml')
 set :sidekiq_require, File.join(current_path, 'boot.rb')

# Global options
# --------------
set :ssh_options, forward_agent: true
