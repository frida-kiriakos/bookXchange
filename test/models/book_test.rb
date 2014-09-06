require 'test_helper'

class BookTest < ActiveSupport::TestCase
	account = Account.new(education: "graduate", 
        email: "frida@csu.fullerton.edu", 
        name: "frida", 
        password: "test123", 
        password_confirmation: "test123")
	account.save

# BookTest.1
  test "should not save book without information" do
  	book = Book.new
  	assert !book.save
  end

# BookTest.2
  test "should not save book without a title" do
  	book = Book.new(title: "", author:"stephen king", edition:"1",course: "english", account_id: account.id)
  	assert !book.save
  end

# BookTest.3
  test "should not save book without an author" do
  	book = Book.new(title: "Dreamcatcher", author: "", edition:"1", course: "english", account_id: account.id)
  	assert !book.save
  end

# BookTest.4
  test "should belong to an account" do
  	book = account.books.build(title: "Dreamcatcher", author: "stephen king", edition:"1", course: "english")
  	assert book.save
  end
end
