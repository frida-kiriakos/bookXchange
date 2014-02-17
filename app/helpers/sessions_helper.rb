module SessionsHelper
  def sign_in(account)
    cookies.permanent[:remember_token] = account.remember_token
    self.current_user = account
  end

  def current_user=(account)
    @current_user = account
  end

  def current_user
    @current_user ||= Account.find_by(remember_token: cookies[:remember_token])
  end

  def current_user?(account)
    account == current_user
  end

  def signed_in?
    !current_user.blank?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end
