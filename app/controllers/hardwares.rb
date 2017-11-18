class App
  get '/' do
    @hardwares = Hardware.cursor(params[:max_id], params[:per_page]).all
    hardwares = (session[:build] && session[:build][:hardwares]) || session[:hardwares]
    @building_hardwares = Hardware.where_all(id: hardwares.map { |h| h[:id] })
    @next_info = Hardware.next_info(@hardwares.last&.id)
    respond_to do |f|
      f.html { erb :index, layout: :'layout/main' }
      f.json { json(hardwares: hardware_serializer(@hardwares), next_info: @next_info) }
    end
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
      logger.info(e.message)
      flash[:error] = 'Tìm kiếm không thành công, vui lòng thử lại!'
      redirect to('/')
    end
  end

  post '/hardware_list/:hardware_id' do
    id = params[:hardware_id].to_i
    part = params[:part].to_s
    updated = if session[:hardwares].size > 0
                if session[:hardwares].find { |h| h[:id] == id && h[:part] = part }
                  false
                else
                  session[:hardwares].push({ id: id, part: part })
                  true
                end
              else
                session[:hardwares] = [{ id: id, part: part }]
                true
              end

    json(num: session[:hardwares].size, updated: updated)
  end

  delete '/hardware_list/:hardware_id' do
    if session[:hardwares].size > 0
      i = session[:hardwares].find_index { |h| h[:id] == params[:hardware_id].to_i && h[:part] == params[:part].to_s }
      session[:hardwares].slice!(i)
    end
    json(num: session[:hardwares].size)
  end
end
