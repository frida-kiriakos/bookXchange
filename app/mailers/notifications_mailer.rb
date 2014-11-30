class NotificationsMailer < ActionMailer::Base
  default from: "no-reply@bookxchange.com"
  default to: "kiriakos.frida@gmail.com"

  def book_added_email(book)
  	@account = book.account
  	@book = book
  	mail(subject: "a new book is added to our library")
  end

  def invalid_access_email(account)
  	@account = account
  	mail(to: account.email, subject: "invalid access atempt to bookxchange")
  end
end
