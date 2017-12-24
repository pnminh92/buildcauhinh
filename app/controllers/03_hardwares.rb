# frozen_string_literal: true

module Buildcauhinh
  class App
    post '/hardware_list/:hardware_id/remove' do
      part = JSON.parse(request.body.read)['part'].to_s
      hardwares = get_session_hardwares
      deleted = if (i = hardwares.find_index { |h| h[:id] == params[:hardware_id].to_i && h[:part] == part })
                  hardwares.slice!(i)
                  true
                else
                  false
                end
      set_session_hardwares(hardwares)
      json(num: hardwares.size, deleted: deleted)
    end

    post '/hardware_list/:hardware_id' do
      id = params[:hardware_id].to_i
      part = JSON.parse(request.body.read)['part'].to_s
      hardwares = get_session_hardwares
      if (index = hardwares.find_index { |h| h[:part] == part })
        hardwares[index] = { id: id, part: part }
      else
        hardwares.push(id: id, part: part)
      end
      set_session_hardwares(hardwares)
      json(num: hardwares.size)
    end

    post '/search' do
      begin
        @q = JSON.parse(request.body.read)
        @q['providers'] = @q['providers']&.size.to_i.positive? ? @q['providers'] : SETTINGS['hardware_providers']
        @hardwares = Hardware.search(@q).all
        if @hardwares.size.zero?
          @hardwares = Hardware.fetch_from_providers(@q)
          UploadImgToCloudinaryWorker.perform_async(@hardwares.map(&:id)) if @hardwares.size.positive?
        end
        json(html: erb(:'shared/search', locals: { hardwares: @hardwares }))
      rescue StandardError => e
        logger.error(e.message)
        json(html: false)
      end
    end

    get '/parts/:part' do
      ds = Hardware.where(part: params['part'])
      @total = ds.count(:id)
      halt(404) if @total.zero?
      @hardwares = ds.cursor(params[:max_id], params[:per_page]).all
      @next_info = ds.next_info(@hardwares.last&.id)
      respond_to do |f|
        f.html { halt 404 }
        f.json do
          json(html: erb(:'shared/hardware_part', locals: {
            total: @total,
            part: params['part'],
            hardwares: @hardwares,
            next_info: @next_info.merge(part: params['part'])
          }))
        end
      end
    end

    get '/' do
      ds = Hardware.search(params).cursor(params[:max_id], params[:per_page])
      @hardwares = ds.all
      @building_hardwares = Hardware.where_all(id: get_session_hardwares.map { |h| h[:id] }) unless request.xhr?
      @next_info = ds.next_info(@hardwares.last&.id)
      respond_to do |f|
        f.html { erb :index, layout: :'layout/main' }
        f.json { json(html: erb(:'shared/hardwares', locals: { hardwares: @hardwares }), next_info: @next_info.merge(part: params['part'])) }
      end
    end
  end
end
