module Timgialinhkien
  module UserSession
    def current_user
      @current_user ||= User[session[:id]]
    end

    def signed_in?
      !!session[:id]
    end
  end
end
