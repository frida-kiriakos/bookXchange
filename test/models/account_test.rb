require 'test_helper'

class AccountTest < ActiveSupport::TestCase
#recommended to include a test case for each of the validations and methods
  test "should not save account without information" do
  	account = Account.new
  	assert !account.save
  end

  test "should not save account without a name" do
  	account = Account.new(name:"", 
  		email:"frida@csu.fullerton.edu", 
  		password:"test123", 
  		password_confirmation:"test123" )
  	assert !account.save
  end

  test "should not save account without an email" do
  	account = Account.new(name:"frida", 
  		email:"", 
  		password:"test123", 
  		password_confirmation:"test123" )
  	assert !account.save
  end

  test "should not save account with an already existing email" do
  	a = Account.new(name:"frida", 
  		email:"frida.k@csu.fullerton.edu", 
  		password:"test123", 
  		password_confirmation:"test123" )
  	assert a.save

  	b = Account.new(name:"frida kiriakos", 
  		email:"frida.k@csu.fullerton.edu", 
  		password:"test123", 
  		password_confirmation:"test123" )

  	assert !b.save
  end
end
