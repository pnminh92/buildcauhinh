# frozen_string_literal: true

Dir[File.join(settings.root, 'app', 'helpers', '*.rb')].each { |f| require f }

class App < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  helpers Buildcauhinh::UserSession
  helpers Buildcauhinh::Util
  helpers Buildcauhinh::AntiSpam
  helpers Buildcauhinh::Cloudinary

  register Sinatra::RespondWith
  register Sinatra::MultiRoute
  register Sinatra::Namespace
  register Sinatra::Flash

  configure do
    enable :sessions

    use Rack::ConditionalGet
    use Rack::ETag
    use Rack::Protection::AuthenticityToken

    logger = ::Logglier.new('https://logs-01.loggly.com/inputs/068c093e-b540-41aa-8e88-410301994dca/tag/ruby/', threaded: true)
    use Rack::CommonLogger, logger

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(settings.root, 'public')
    set :run, false
    set :server, 'puma'
    set :views, File.join(settings.root, 'app', 'views')
    set :logging, true
    set :json_encoder, :to_json
    set :dump_errors, true
    set :raise_errors, false
    set :show_exceptions, true

    before do
      session[:anti_spam_timestamp] ||= Time.now
      session[:hardwares] ||= []
      env['rack.logger'] = logger
    end

    not_found do
      respond_to do |f|
        f.html { erb :'errors/404', layout: :'layout/simple' }
        f.json { json(html: false) }
      end
    end

    error do
      logger.error(env['sinatra.error'].message)
    end
  end

  configure :development do
    set :session_secret, 'so_so_secret'
  end

  configure :production do
    set :session_secret, ENV['BUILDCAUHINH_SESSION_SECRET']
    set :show_exceptions, false
  end
end

SETTINGS = YAML.load_file(File.join(settings.root, 'config', 'settings.yml').to_s).freeze
tmp_assets = JSON.parse(File.read(File.join(settings.root, 'config', 'rev-manifest.json').to_s))
ASSETS = tmp_assets.keys.map { |k| { k.to_s => '/assets/' + tmp_assets[k] } }.reduce({}, :merge).freeze

Dir[File.join(settings.root, 'config', 'initializers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'lib', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'lib', 'providers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'uploaders', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'models', 'concerns', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'models', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'workers', '*.rb')].each { |f| require f }
Dir[File.join(settings.root, 'app', 'controllers', '*.rb')].sort.each { |f| require f }
