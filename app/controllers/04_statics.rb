class App
  get '/about' do
    erb :'statics/about', layout: :'layout/simple'
  end

  get '/contact' do
    erb :'statics/contact', layout: :'layout/simple'
  end
end
