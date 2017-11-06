class App
  get '/signup' do
    erb :'users/signup', layout: 'layout/main'
  end

  post '/signup' do
    @user = User.new
    if @user.set_fields(params, %i[username email password], missing: :skip).save
      status 200
      redirect to('/')
    else
      @errors = @user.errors
      status 422
      erb :'user/signup'
    end
  end

  get '/forgot_pwd' do
    erb :'users/forgot_pwd', layout: 'layout/main'
  end

  post '/forgot_pwd' do
  end

  get '/reset_pwd' do
    erb :'users/reset_pwd', layout: 'layout/main'
  end

  post '/reset_pwd' do
  end

  get '/change_pwd' do
    erb :'users/change_pwd', layout: 'layout/main'
  end

  post '/change_pwd' do
    unless current_user.authenticate(params[:current_password])
      @errors = 'Mật khẩu hiện tại không đúng'
      halt erb(:'users/change_pwd')
    else
    unless current_user.update(password: params['new_password'])
      @errors = current_user.errors
      erb(:'users/change_pwd')
    end
  end

  get '/signin' do
    erb :'users/signin', layout: 'layout/main'
  end

  post '/signin' do
    @user = User.where(username: params[:username]).first
    if @user && @user.authenticate(params[:password])
      session[:username] = @user.username
      redirect back
    else
      @error = 'Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại!'
      erb :'users/signin', layout: 'layout/main'
    end
  end

  delete '/signout' do
    session[:username] = nil
    redirect back
  end

  get '/:username' do
    @user = User.where(username: username).first
    halt 404 unless @user
    erb :'users/show', layout: 'layout/main'
  end

  get '/settings' do
    erb :'users/settings', layout: 'layout/main'
  end

  route :patch, :put, '/settings' do
    current_user.update_fields(params, %i[username email], missing: :skip).save
    @errors = current_user.errors if current_user.errors
    erb :'users/settings', layout: 'layout/main'
  end
end
