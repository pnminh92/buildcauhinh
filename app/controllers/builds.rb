class App
  ALLOWED_BUILD_PARAMS = %i[title price_type cpu_type price_showed provider_showed]

  namespace '/builds' do
    get do
      @builds = Build.limit(10).order(Sequel.desc(:id)).all
      erb :'builds/index', layout: :'layout/main'
    end

    get '/new' do
      erb :'builds/new', layout: :'layout/main'
    end

    get '/edit' do
      erb :'builds/edit', layout: :'layout/main'
    end

    get '/:slug' do
      @build = Build.first(slug: params[:slug].to_s)
      halt 404 unless @build
      @comments = @build.comments
      @new_builds = Build.limit(5).order(Sequel.desc(:id)).all
      erb :'builds/show', layout: :'layout/main'
    end

    post do
      @build = Build.new
      if @build.set_fields(params, ALLOWED_BUILD_PARAMS).save
        status 201
        json(message: 'Created')
      else
        status 422
        json @build.errors
      end
    end

    patch '/:id' do
      @build = Build[params[:id]]
      halt 404 unless @build
      if @build.update_fields(params, ALLOWED_BUILD_PARAMS)
        status 200
        json @build
      else
        status 422
        json @build.errors
      end
    end

    delete '/:id' do
      @build = Build[params[:id]]
      halt 404 unless @build
      @build.destroy
      status 200
      json(message: 'Deleted')
    end
  end
end
