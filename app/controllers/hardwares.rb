class App
  get '/' do
    @hardwares = Hardware.cursor(params[:max_id], params[:per_page]).all
    hardwares = get_session_hardwares
    @building_hardwares = Hardware.where_all(id: hardwares.map { |h| h[:id] })
    @next_info = Hardware.next_info(@hardwares.last&.id)
    respond_to do |f|
      f.html { erb :index, layout: :'layout/main' }
      f.json { json(html: erb(:'shared/hardwares', locals: { hardwares: @hardwares }), next_info: @next_info) }
    end
  end

  post '/search' do
    begin
      @q = JSON.parse(request.body.read)
      @q['providers'] = @q['providers']&.size.to_i > 0 ? @q['providers'] : SETTINGS['hardware_providers']
      @hardwares = Hardware.search(@q).all
      @hardwares = Hardware.fetch_from_providers(@q) if @hardwares.size.zero?
      json(html: erb(:'shared/search', locals: { hardwares: @hardwares }))
    rescue NameError => e
      logger.info(e.message)
      json(html: false)
    end
  end

  post '/hardware_list/:hardware_id' do
    id = params[:hardware_id].to_i
    part = JSON.parse(request.body.read)['part'].to_s
    hardwares = get_session_hardwares
    logger.info(hardwares)
    replaced = if index = hardwares.find_index { |h| h[:part] == part }
                 hardwares[index] = { id: id, part: part }
                 true
               else
                 hardwares.push({ id: id, part: part })
                 false
               end
    set_session_hardwares(hardwares)
    json(num: hardwares.size, replaced: replaced)
  end

  post '/hardware_list/:hardware_id/remove' do
    part = JSON.parse(request.body.read)['part'].to_s
    hardwares = get_session_hardwares
    deleted = if i = hardwares.find_index { |h| h[:id] == params[:hardware_id].to_i && h[:part] == part }
                 hardwares.slice!(i)
                 true
               else
                 false
               end
    set_session_hardwares(hardwares)
    json(num: hardwares.size, deleted: deleted)
  end
end
