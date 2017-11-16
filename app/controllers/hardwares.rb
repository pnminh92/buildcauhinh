class App
  get '/' do
    @hardwares = Hardware.limit(10).order(Sequel.desc(:id)).all
    @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
    erb :index, layout: :'layout/main'
  end

  post '/search' do
    begin
      @q = params
      @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
      @q[:providers] ||= SETTINGS['hardware_providers']
      @hardwares = Hardware.where(provider: @q[:providers])
                           .grep(:name, @q[:word].strip.split(' ').map { |w| "%#{w}%" }, all_patterns: true, case_insensitive: true)
                           .all
      if @hardwares.size.zero?
        tmp = []
        @q[:providers].each { |provider| tmp.concat(Providers.const_get(provider.capitalize.gsub('_', '')).search(@q[:word])) }
        Hardware.import(%i[code name price url image_url provider], tmp.map(&:values)) if tmp.size > 0
        @hardwares = Hardware.where_all(code: tmp.map { |o| o[:code] })
      end
      erb :search, layout: :'layout/main'
    rescue NameError => e
      logger.error(e.message)
      halt 500
    end
  end

  post '/hardware_list/:hardware_id' do
    id = params[:hardware_id].to_i
    if session[:hardware_ids].is_a?(Array)
      session[:hardware_ids].push(id) unless session[:hardware_ids].include?(id)
    else
      session[:hardware_ids] = [id]
    end
    json(num: session[:hardware_ids].size)
  end

  delete '/hardware_list/:hardware_id' do
    if session[:hardware_ids].is_a?(Array)
      i = session[:hardware_ids].index(params[:hardware_id].to_i)
      session[:hardware_ids].slice!(i)
    else
      session[:hardware_ids] = []
    end
    json(num: session[:hardware_ids].size)
  end
end
