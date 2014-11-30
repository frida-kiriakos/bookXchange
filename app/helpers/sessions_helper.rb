module SessionsHelper
  def sign_in(account)
    cookies.permanent[:remember_token] = account.remember_token
    self.current_user = account
  end

  def current_user=(account)
    @current_user = account
  end

  def current_user
    @current_user ||= Account.find_by(:remember_token => cookies[:remember_token])
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
    # might need to save the page in return_to before calling this function
    # update: there is already a store_location method that does that
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
    session.delete(:admin_access)
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

  def signed_in_admin_user
    unless signed_in?    
      store_location
      session[:admin_access] = true
      redirect_to signin_url, notice: "Please sign in with your admin account."
    end
  end

  def is_admin?
    if current_user.admin?
      # check profile
      valid, flag_attempt = check_profile(current_user)

      if not valid
        sign_out
        redirect_to root_url, notice: "You were not identified as admin, this incident will be reported"
      end
    else
      redirect_to root_url, notice: "You must be admin to access this page"
    end
  end

  def auth_logger
     @auth_logger ||= Logger.new("#{Rails.root}/log/authentication.log")
  end

  def check_profile(account)
    profile = account.profile
    if profile
      score = 0
      result = ""
      # check pages, pages will have less weight since it is most likely to contain /admin 
      if profile.pages.include?("/admin")
        score += 10
      else
        result += "user does not usually access admin page"
      end
      # check ip_address, exact match or same subnet
      addresses = profile.ip_address.split(',')

      addresses.each do |addr|
        net = IPAddr.new(addr).mask(24)
        if request.remote_ip == addr 
          score += 20
        elsif net.include?(request.remote_ip)
          score += 15
        # else
        #   result += ", user is not in the usual location"
        end
      end

      if score <= 10
        result += ", user is not in the usual location"
      end

      # check access time, if access time is around the usual access time within an hour more or less, give a lower score instead of 0
      t = Time.now.hour
      if t == profile.access_time
        score += 25
      elsif t == profile.access_time - 1 or  t == profile.access_time + 1
        score += 15
      else
        result += ", access time is not around the usual time"
      end

      # check browser used
      user_agent = request.headers['User-Agent']

      if user_agent.include?(profile.browser)
        score += 20
      else
        result += ", user is not using the usual browser"
      end

      if user_agent.include?(profile.operating_system)
        score += 25
      else
        result += ", user is not using the usual OS"
      end

      
      # if score is within 70% it is a valid attempt, less than 70% flag a warning, less than  50%, then attempt is invalid, inform the admin of this attempt, these numbers might need tweaking.

      if score >= 70
        flag_attempt = "valid"
        valid = true
      elsif score < 70 and score >= 50
        flag_attempt = "warning"
        valid = true
      else
        flag_attempt = "invalid"
        valid = false
      end

      auth_logger.info "admin access attempt with: Account: #{account.id}, final score: #{score}, result: #{result}, decision: #{flag_attempt}"

      return valid, flag_attempt

    else
      store_location
      # must redirect to a page with security question
      redirect_to root_url, notice: "Please enter answer to your security question"
    end    
  end
end
