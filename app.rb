# frozen_string_literal: true

Dir[File.join(settings.root, 'app', 'helpers', '*.rb')].each { |f| require f }

class App < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  helpers BuildCasePc::UserSession
  helpers BuildCasePc::Util
  helpers BuildCasePc::AntiSpam

  register Sinatra::RespondWith
  register Sinatra::MultiRoute
  register Sinatra::Namespace
  register Sinatra::Flash

  configure do
    enable :sessions

    use Rack::Deflater
    use Rack::ConditionalGet
    use Rack::ETag

    use Rack::Protection
    use Rack::Protection::AuthenticityToken

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

    before {
      session[:anti_spam_timestamp] ||= Time.now
      session[:hardwares] ||= []
    }

    not_found do
      erb :'errors/404', layout: :'layout/simple'
    end
  end

  configure :development do
    set :session_secret, proc { 'so_so_secret' }
  end

  configure :production do
    set :session_secret, proc { ENV['BUILDCAUHINH_SESSION_SECRET'] }
    set :show_exceptions, false

    error_log_file = File.new("#{root}/log/#{settings.environment}_error.log", 'a+')
    error_log_file.sync = true
    before {
      env['rack.errors'] =  error_log_file
    }
  end
end

SETTINGS = YAML.load_file(File.join(settings.root, 'config', 'settings.yml').to_s).freeze
tmp_assets = JSON.parse(File.read(File.join(settings.root, 'config', 'rev-manifest.json').to_s))
ASSETS = tmp_assets.keys.map { |k| { "#{k}" => '/assets/' + tmp_assets[k] } }.reduce({}, :merge).freeze

Dir[File.join(settings.root, 'config', '*.rb')].each { |f| require f unless f.include?('deploy.rb') }
Dir[File.join(settings.root, 'lib', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'lib', 'providers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'uploaders', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'models', 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'models', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'workers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'controllers', '*.rb')].each { |f| require f }
