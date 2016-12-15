module SessionsHelper

  def log_in(user)
    session[:user_ids] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_ids] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
   # @current_user ||= User.find_by(id: session[:user_ids])
    if (user_ids = session[:user_ids])
      @current_user ||= User.find_by(id: user_ids)
    elsif (user_ids = cookies.signed[:user_ids])
      user = User.find_by(id: user_ids)
      #if user && user.authenticated?(cookies[:remember_token])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

   # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_ids)
    @current_user = nil
  end


  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end


  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_ids)
    cookies.delete(:remember_token)
  end
end
