class App
  get '/about' do
    erb :'statics/about', layout: 'layout/main'
  end

  get '/tos' do
    erb :'statics/tos', layout: 'layout/main'
  end

  get '/privacy' do
    erb :'statics/privacy', layout: 'layout/main'
  end
end
