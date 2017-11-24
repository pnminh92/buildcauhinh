require 'yaml'

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

db_config = YAML.load_file('./config/database.yml')[ENV.fetch('RACK_ENV') { 'development' }]
db_url = "postgres://localhost/#{db_config['database']}?user=#{db_config['username']}&password=#{db_config['password']}"

desc 'Update model annotations'
task :annotate do
  require 'sequel/annotate'
  require_relative 'boot'
  Sequel::Annotate.annotate(Dir['./app/models/*.rb'], position: :before)
end

namespace :db do
  namespace :migrate do
    desc 'Reset database'
    task :reset do
      system!("PGPASSWORD=#{db_config['password']} dropdb #{db_config['database']} --username=#{db_config['username']}")
      system!("PGPASSWORD=#{db_config['password']} createdb #{db_config['database']} --username=#{db_config['username']} --encoding=#{db_config['encoding']}")
      system!("sequel -m db/migrations '#{db_url}'")
    end
  end

  desc 'Drop database'
  task :drop do
    system!("PGPASSWORD=#{db_config['password']} dropdb #{db_config['database']} --username=#{db_config['username']}")
  end

  desc 'Create database'
  task :create do
    system!("PGPASSWORD=#{db_config['password']} createdb #{db_config['database']} --username=#{db_config['username']} --encoding=#{db_config['encoding']}")
  end

  desc 'Run migrations'
  task :migrate do
    system!("sequel -m db/migrations '#{db_url}'")
  end

  desc 'Seed data'
  task :seed do
    require_relative 'db/seed'
  end
end
