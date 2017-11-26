class App
  ALLOWED_BUILD_PARAMS = %i[user_id title description total_price price_showed provider_showed hardware_ids]

  get '/builds' do
    ds = Build.search(params).cursor(params[:max_id], params[:per_page])
    @builds = ds.all
    @next_info = ds.next_info(@builds.last&.id)
    @params = params
    respond_to do |f|
      f.html { erb :'builds/index', layout: :'layout/main' }
      f.json { json(html: erb(:'shared/builds', locals: { builds: @builds }), next_info: @next_info) }
    end
  end

  post '/builds' do
    detect_spam!
    halt 404 unless signed_in?
    begin
      @build = Build.new.set_fields(params, ALLOWED_BUILD_PARAMS)
      DB.transaction do
        @build.save(raise_on_failure: true)
        BuildsHardware.build(@build.id, params[:hardware_ids])
      end
      session[:hardwares] = nil
      flash[:success] = I18n.t('views.create_build_success')
      redirect to("/#{current_user.username}")
    rescue StandardError => e
      logger.info(e.message)
      @hardwares = Hardware.where_all(id: session[:hardwares].map { |h| h[:id] }) || []
      @total_price = Build.total_price(@hardwares)
      @cpu_type = Build.detect_cpu_type(@hardwares)
      erb :'builds/new', layout: :'layout/main'
    end
  end

  namespace '/builds' do
    get '/new' do
      @build = Build.new
      @hardwares = Hardware.where_all(id: session[:hardwares].map { |h| h[:id] }) || []
      @total_price = Build.total_price(@hardwares)
      @cpu_type = Build.detect_cpu_type(@hardwares)
      erb :'builds/new', layout: :'layout/main'
    end

    get '/:id/edit' do
      @build = Build.find(id: params[:id], user_id: current_user&.id)
      halt 404 unless @build
      if session[:build]
        @hardwares = Hardware.where_all(id: session[:build][:hardwares].map { |h| h[:id] })
      else
        @hardwares = @build.hardwares
        session[:build] = {
          id: @build.id,
          hardwares: @hardwares.map { |h| { id: h.id, part: h.part } }
        }
      end
      @total_price = Build.total_price(@hardwares)
      @cpu_type = Build.detect_cpu_type(@hardwares)
      erb :'builds/edit', layout: :'layout/main'
    end

    get '/:slug' do
      @build = Build.first(slug: params[:slug].to_s)
      halt 404 unless @build
      @comments = Build.where(slug: params[:slug].to_s).comments.order(Sequel.desc(:id))
      @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
      @hardwares = @build.hardwares
      @total_price = Build.total_price(@hardwares)
      erb :'builds/show', layout: :'layout/main'
    end

    post '/:id/update' do
      @build = Build.find(id: params[:id], user_id: current_user&.id)
      halt 404 unless @build
      if @build.update_fields(params, ALLOWED_BUILD_PARAMS)
        session[:build] = nil
        redirect to("/builds/#{@build.slug}")
      else
        @hardwares = Hardware.where_all(id: session[:build][:hardwares].map { |h| h[:id] })
        erb :"builds/edit", layout: :'layout/main'
      end
    end

    post '/:id/cancel_edit' do
      @build = Build.find(id: params[:id], user_id: current_user&.id)
      halt 404 unless @build
      session[:build] = nil
      status 200
      json(to: to("/builds/#{@build.slug}"))
    end

    post '/:id/delete' do
      @build = Build.find(id: params[:id], user_id: current_user&.id)
      halt 404 unless @build
      @build.destroy
      session[:build] = nil if session[:build] && (session[:build][:id] == @build.id)
      redirect to('/builds')
    end
  end
end
