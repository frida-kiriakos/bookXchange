class SessionsController < ApplicationController
  def new
  end

  def create
  	account = Account.find_by(:email => params[:session][:email])
  
    #  so we check here if the return_to url is admin then check the profile
    if session[:admin_access] == true and session[:return_to].include?("/admin")
      logger.info "======== checking admin profile"
    end

    if account and account.authenticate(params[:session][:password])
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
