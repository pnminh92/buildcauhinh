class App
  ALLOWED_BUILD_PARAMS = %i[title price_type cpu_type price_showed provider_showed]

  namespace '/builds' do
    get do
      @builds = Build.all.order(:id)
      erb :'builds/index', layout: 'layout/main'
    end

    get '/:id' do
      begin
        @build = Build[params[:id]]
        erb :'builds/show', layout: 'layout/main'
      rescue NoMatchingRow
        halt 404
      end
    end

    post do
      @build = Build.new
      if @build.set_fields(params, ALLOWED_BUILD_PARAMS, missing: :skip).save
        status 201
        json { message: 'Created' }
      else
        status 422
        json @build.errors
      end
    end

    route :patch, :put, '/:id' do
      begin
        @build = Build.with_pk!(params[:id])
        if @build.update_fields(params, ALLOWED_BUILD_PARAMS, missing: :skip)
          status 200
          json @build
        else
          status 422
          json @build.errors
        end
      rescue NoMatchingRow
        halt 404
      end
    end

    delete '/:id' do
      begin
        @build = Build.with_pk!(params[:id])
        @build.destroy
        status 200
        json { message: 'Deleted' }
      rescue NoMatchingRow
        halt 404
      end
    end
  end
end
