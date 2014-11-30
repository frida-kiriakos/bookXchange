class SessionsController < ApplicationController
  def new
  end

  def create
  	account = Account.find_by(:email => params[:session][:email])    

    if account and account.authenticate(params[:session][:password])
       # check the account profile if it corresponds to an admin
      # if session[:admin_access] == true and session[:return_to].include?("/admin")
      if session[:return_to] and session[:return_to].include?("/admin")
        
        valid,flag_attempt = check_profile account      

        if !valid.nil? and valid == false
          auth_logger.info "invalid login attempt"
          flash.now[:error] = "You were not identified as an admin, this incident will be reported"
          session.delete(:return_to)
          render 'new' and return
        end
      end
      #fill user session
      sign_in account
      account.update_column(:num_logins, account.num_logins + 1)
      flash[:success] = "Logged in successfully"
      redirect_back_or account
    else
      flash.now[:error] = "Invalid Email or Password"
      render 'new'
    end
  end

  def destroy
  	sign_out 
    redirect_to root_url
  end
end
