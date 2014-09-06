class SessionsController < ApplicationController
  def new
  end

  def create
  	account = Account.find_by(:email => params[:session][:email])
    if account and account.authenticate(params[:session][:password])
      #fill user session
      sign_in account
      flash[:success] = "Logged in successfully"
      redirect_to account
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
