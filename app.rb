# frozen_string_literal: true

class App < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON
  register Sinatra::MultiRoute
  register Sinatra::Namespace

  configure do
    enable :sessions

    use Rack::Deflater
    use Rack::ConditionalGet
    use Rack::ETag

    set :root, File.dirname(__FILE__)
    set :public_folder, proc { File.join(settings.root, 'public') }
    set :enviroment, ENV.fetch('RACK_ENV') { 'development' }
    set :run, false
    set :server, 'puma'
    set :views, proc { File.join(settings.root, 'app', 'views') }

    set :logging, true
    logger = ::Logger.new("#{settings.root}/log/#{settings.environment}_access.log")
    use Rack::CommonLogger, logger

    set :json_encoder, :to_json

    set :dump_errors, true
    set :raise_errors, false
    set :show_exceptions, true
  end

  configure :production do
    use Rack::Protection
    set :show_exceptions, false

    error_log_file = File.new("#{root}/log/#{settings.environment}_error.log", 'a+')
    error_log_file.sync = true
    before {
      env['rack.errors'] =  error_log_file
    }
  end

  DB = Sequel.connect(YAML.load_file(File.join(settings.root, 'config', 'database.yml').to_s)[ENV.fetch('RACK_ENV') { 'development' }])
  DB.extension :pagination

  Sequel::Model.raise_on_save_failure = false
  Sequel::Model.plugin :association_dependencies
  Sequel::Model.plugin :json_serializer
  Sequel::Model.plugin :validation_helpers
  Sequel::Model.plugin :timestamps
end

Dir['./lib/providers/*.rb'].each { |f| require f }
Dir['./app/models/*.rb'].each { |f| require f }
Dir['./app/controllers/*.rb'].each { |f| require f }
