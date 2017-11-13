class App
  get '/' do
    @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
    erb :index, layout: :'layout/main'
  end

  post '/search' do
    begin
      q = JSON.parse(request.body.read)
      hardwares = []
      providers = q[:providers] || settings.hardware_providers
      providers.each { |provider| hardwares << hardwares.concat(Object.const_get(provideer.capitalize).search(q[:word])) }
      json hardwares
    rescue NameError => e
      logger.error(e.message)
      status 500
      json(message: 'Hệ thống xảy ra lỗi. Vui lòng thử lại!')
    end
  end
end
