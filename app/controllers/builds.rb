class App
  ALLOWED_BUILD_PARAMS = %i[user_id title description price_type cpu_type price_showed provider_showed]

  namespace '/builds' do
    get do
      @builds = Build.search(params).limit(10).order(Sequel.desc(:id)).all
      @params = params
      erb :'builds/index', layout: :'layout/main'
    end

    get '/new' do
      @build = Build.new
      @hardwares = Hardware.where_all(id: session[:hardware_ids]) || []
      erb :'builds/new', layout: :'layout/main'
    end

    get '/:id/edit' do
      @build = Build[params[:id]]
      halt 404 unless @build
      if session[:build]
        @hardwares = Hardware.where_all(id: session[:build][:hardware_ids])
      else
        @hardwares = @build.hardwares
        session[:build] = {
          id: @build.id,
          hardware_ids: @hardwares.map(&:id)
        }
      end
      erb :'builds/edit', layout: :'layout/main'
    end

    get '/:slug' do
      @build = Build.first(slug: params[:slug].to_s)
      halt 404 unless @build
      @comments = Build.where(slug: params[:slug].to_s).comments.order(Sequel.desc(:id))
      @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
      @hardwares = @build.hardwares
      erb :'builds/show', layout: :'layout/main'
    end

    post do
      begin
        @build = Build.new.set_fields(params, ALLOWED_BUILD_PARAMS)
        raise 'Invalid hardware_ids param' unless params[:hardware_ids].is_a?(Array)
        DB.transaction do
          @build.save
          BuildsHardware.build(@build.id, params[:hardware_ids])
        end
        session[:hardware_ids] = nil
        redirect to('/')
      rescue StandardError => e
        logger.info(e.message)
        @hardwares = Hardware.where_all(id: session[:hardware_ids]) || []
        erb :'builds/new', layout: :'layout/main'
      end
    end

    post '/:id/update' do
      @build = Build[params[:id]]
      halt 404 unless @build
      if @build.update_fields(params, ALLOWED_BUILD_PARAMS)
        session[:build] = nil
        redirect to("/builds/#{@build.slug}")
      else
        @hardwares = Hardware.where_all(id: session[:build][:hardware_ids])
        erb :"builds/edit", layout: :'layout/main'
      end
    end

    post '/:id/cancel_edit' do
      @build = Build[params[:id]]
      halt 404 unless @build
      session[:build] = nil
      status 200
      json(to: to("/builds/#{@build.slug}"))
    end

    post '/:id/delete' do
      @build = Build[params[:id]]
      halt 404 unless @build
      @build.destroy
      session[:build] = nil if session[:build] && (session[:build][:id] == @build.id)
      redirect to('/builds')
    end
  end
end
