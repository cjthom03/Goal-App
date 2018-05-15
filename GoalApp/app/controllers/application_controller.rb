class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_token!
  end
  
  def current_user
    return nil if session[:session_token] == nil 
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
  
  def logged_in?
    !!current_user
  end
  
  def ensure_logged_in
    redirect_to new_session_url unless logged_in?
  end

end
