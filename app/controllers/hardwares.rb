class App
  get '/' do
    @hardwares = Hardware.recent
    @builds = Build.limit(5).order(:id)
    erb :index, layout: :'layout/main'
  end

  post '/hardwares' do
  end
end
