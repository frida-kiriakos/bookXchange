require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  ###### what to test:
  # was the web request successful?
  # was the user redirected to the right page?
  # was the user successfully authenticated?
  # was the correct object stored in the response template?
  # was the appropriate message displayed to the user in the view?
  setup do
    @account = accounts(:one)    
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: { 
        education: "graduate", 
        email: "frida@csu.fullerton.edu", 
        name: "frida", 
        password: "test123", 
        password_confirmation: "test123" }
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should show account" do
    get :show, id: @account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account
    assert_response :success
  end

  test "should update account" do
    patch :update, id: @account, account: { address: @account.address, education: @account.education, email: @account.email, name: @account.name, password: "test123", password_confirmation: "test123" }
    assert_redirected_to account_path(assigns(:account))
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account
    end

    assert_redirected_to accounts_path
  end
end
