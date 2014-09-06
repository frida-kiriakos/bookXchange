class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  
  def index
    @accounts = Account.all
  end

  
  def show
    @books = @account.books
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      sign_in @account
      flash[:success] = "Thank you for registering on bookXchange"
      redirect_to @account
    else
      render 'new'
    end
  end
 
  def update
    if @account.update(account_params)
      sign_in @account
      flash[:success] = "Account was successfully updated."
      redirect_to @account
    else
      render 'edit'
    end
  end

  
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :email, :education, :address, :password, :password_confirmation )
    end
end
