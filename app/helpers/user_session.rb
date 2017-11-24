module BuildCasePc
  module UserSession
    def current_user
      @current_user ||= User[session[:id]]
    end

    def signed_in?
      !!session[:id]
    end

    def set_session_hardwares(hardwares)
      if session[:build] && session[:build][:hardwares]
        session[:build][:hardwares] = hardwares
      else
        session[:hardwares] = hardwares
      end
    end

    def get_session_hardwares
      (session[:build] && session[:build][:hardwares]) || session[:hardwares]
    end
  end
end
