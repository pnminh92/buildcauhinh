# frozen_string_literal: true

Dir[File.join(settings.root, 'app', 'helpers', '*.rb')].each { |f| require f }

class App < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  helpers Timgialinhkien::UserSession
  helpers Timgialinhkien::Util

  register Sinatra::MultiRoute
  register Sinatra::Namespace

  configure do
    enable :sessions

    use Rack::Deflater
    use Rack::ConditionalGet
    use Rack::ETag

    set :root, File.dirname(__FILE__)
    set :public_folder, proc { File.join(settings.root, 'public') }
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

  configure :development do
    set :session_secret, proc { 'so_so_secret' }
  end

  configure :production do
    use Rack::Protection
    set :session_secret, proc { ENV['SESSION_SECRET'] }
    set :show_exceptions, false

    error_log_file = File.new("#{root}/log/#{settings.environment}_error.log", 'a+')
    error_log_file.sync = true
    before {
      env['rack.errors'] =  error_log_file
    }
  end
end

SETTINGS = YAML.load_file(File.join(settings.root, 'config', 'settings.yml').to_s).freeze

Dir[File.join(settings.root, 'config', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'lib', 'providers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'uploaders', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'models', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'workers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'controllers', '*.rb')].each { |f| require f }
