class App
  get '/sign_up' do
    redirect(to('/')) && return if signed_in?
    @user = User.new
    erb :'users/sign_up', layout: :'layout/simple'
  end

  post '/sign_up' do
    detect_spam!
    redirect(to('/')) && return if signed_in?

    @user = User.new
    if @user.set_fields(params, %i[username password]).save
      flash[:success] = I18n.t('controllers.users.sign_up_success')
      redirect to('/')
    else
      @errors = @user.errors
      erb :'users/sign_up', layout: :'layout/simple'
    end
  end

  get '/sign_in' do
    redirect(to('/')) && return if signed_in?

    erb :'users/sign_in', layout: :'layout/simple'
  end

  post '/sign_in' do
    redirect(to('/')) && return if signed_in?

    @user = User.where(username: username(params[:username])).first
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect to('/')
    else
      @error = I18n.t('controllers.users.sign_in_error')
      erb :'users/sign_in', layout: :'layout/simple'
    end
  end

  post '/sign_out' do
    session[:id] = nil
    redirect to('/')
  end

  get '/forgot_pwd' do
    redirect(to('/')) && return if signed_in?

    erb :'users/forgot_pwd', layout: :'layout/simple'
  end

  post '/forgot_pwd' do
    detect_spam!
    @user = User.where(email: params[:email]).first
    if @user
      @user.gen_reset_pwd_token
      SendResetPwdTokenWorker.perform_async(@user.id)
      flash[:success] = I18n.t('controllers.users.forgot_pwd_success')
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
      if @user.set_fields(params, %i[password]).save
        flash[:success] = I18n.t('controllers.users.reset_pwd_success')
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
    halt 404 unless signed_in?
    erb :'users/change_pwd', layout: :'layout/main'
  end

  post '/settings/change_pwd' do
    halt 404 unless signed_in?
    if !current_user.authenticate(params[:current_password])
      @error = I18n.t('controllers.users.change_pwd_error')
    elsif !current_user.set_fields(params, %i[password]).save
      @errors = current_user.errors
    else
      flash.now[:success] = 'Đổi mật khẩu thành công'
    end
    erb :'users/change_pwd', layout: :'layout/main'
  end

  get '/settings' do
    halt 404 unless signed_in?
    erb :'users/settings', layout: :'layout/main'
  end

  get '/:username' do
    @user = User.first(username: params[:username])
    halt 404 unless @user
    @builds = User.where(username: params[:username]).builds.cursor(params[:max_id], params[:per_page]).all
    @next_info = Build.next_info(@builds.last.id)
    respond_to do |f|
      f.html { erb :'users/show', layout: :'layout/main' }
      f.json { json(html: erb(:'shared/builds', locals: { builds: @builds }), next_info: @next_info) }
    end
  end

  post '/settings' do
    halt 404 unless signed_in?
    current_user.set_fields(params, %i[avatar email about]).save
    @errors = current_user.errors if current_user.errors
    erb :'users/settings', layout: :'layout/main'
  end
end
