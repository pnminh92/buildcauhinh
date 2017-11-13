class App
  get '/sign_up' do
    redirect(to('/')) && return if session[:id]

    erb :'users/sign_up', layout: :'layout/simple'
  end

  post '/sign_up' do
    redirect(to('/')) && return if session[:id]

    @user = User.new
    @user.username = username(params[:username]) if params[:username]
    if @user.set_fields(params, %i[password]).save
      redirect to('/')
    else
      @errors = @user.errors
      erb :'users/sign_up', layout: :'layout/simple'
    end
  end

  get '/sign_in' do
    redirect(to('/')) && return if session[:id]

    erb :'users/sign_in', layout: :'layout/simple'
  end

  post '/sign_in' do
    redirect(to('/')) && return if session[:id]

    @user = User.where(username: username(params[:username])).first
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect to('/')
    else
      @error = I18n.t('controllers.users.sign_in_error')
      erb :'users/sign_in', layout: :'layout/simple'
    end
  end

  delete '/sign_out' do
    session[:id] = nil
  end

  get '/forgot_pwd' do
    redirect(to('/')) && return if session[:id]

    erb :'users/forgot_pwd', layout: :'layout/simple'
  end

  post '/forgot_pwd' do
    @user = User.where(email: params[:email]).first
    if @user
      @user.gen_reset_pwd_token
      SendResetPwdTokenWorker.perform_async(@user.id)
      redirect to('/sign_in')
    else
      @error = I18n.t('controllers.users.forgot_pwd_error')
      erb :'users/forgot_pwd', layout: :'layout/simple'
    end
  end

  get '/reset_pwd' do
    @token = params[:token]
    erb :'users/reset_pwd', layout: :'layout/simple'
  end

  post '/reset_pwd' do
    @user = User.where(reset_pwd_token: params[:reset_pwd_token]).first
    @token = params[:reset_pwd_token]
    if @user && @user.reset_pwd_token_valid?
      if @user.update(password: params[:password])
        redirect to('/sign_in')
      else
        @errors = @user.errors
        erb :'users/reset_pwd', layout: :'layout/simple'
      end
    else
      @error = I18n.t('controllers.users.reset_pwd_error')
      erb :'users/reset_pwd', layout: :'layout/simple'
    end
  end

  get '/settings/change_pwd' do
    erb :'users/change_pwd', layout: :'layout/main'
  end

  post '/settings/change_pwd' do
    unless current_user.authenticate(params[:current_password])
      @error = I18n.t('controllers.users.change_pwd_error')
      halt erb(:'users/change_pwd', layout: :'layout/main')
    end
    unless current_user.update(password: params['new_password'])
      @errors = current_user.errors
    end
    erb :'users/change_pwd', layout: :'layout/main'
  end

  get '/settings' do
    @user = current_user
    erb :'users/settings', layout: :'layout/main'
  end

  get '/:username' do
    @user = User.first(username: params[:username])
    halt 404 unless @user
    @builds = Build.limit(10).order(Sequel.desc(:id)).all
    erb :'users/show', layout: :'layout/main'
  end

  post '/settings' do
    @user = current_user
    @user.username = username(params[:username]) if params[:username]
    @user.update_fields(params, %i[email about])
    @errors = current_user.errors if @user.errors
    erb :'users/settings', layout: :'layout/main'
  end
end
