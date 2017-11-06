require 'yaml'

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

db_config = YAML.load_file('./config/database.yml')[ENV.fetch('RACK_ENV') { 'development' }]
db_url = "postgres://localhost/#{db_config[:database]}?user=#{db_config[:username]}&password=#{db_config[:password]}"

desc 'Update model annotations'
task :annotate do
  require 'sequel/annotate'
  Sequel.connect(db_config)
  model_files = Dir['app/models/*.rb']
  model_files.each { |f| require "./#{f}" }
  Sequel::Annotate.annotate(model_files, position: :before)
end

namespace :db do
  namespace :migrate do
    desc 'Reset database'
    task :reset do
      system!("PGPASSWORD=gamegame psql 'DROP DATABASE #{db_config[:database]}'")
      system!("PGPASSWORD=gamegame psql 'CREATE DATABASE #{db_config[:database]} ENCODING \'UTF-8\''")
      system!("sequel -m db/migrations '#{db_url}'")
    end
  end

  desc 'Run migrations'
  task :migrate do
    system!("sequel -m db/migrations '#{db_url}'")
  end

  desc 'Seed data'
  task :seed do
  end
end
