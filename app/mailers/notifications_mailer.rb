class NotificationsMailer < ActionMailer::Base
  default from: "no-reply@bookXchange.com"
  default to: "kiriakos.frida@gmail.com"

  def book_added_email(book)
  	@account = book.account
  	@book = book
  	mail(subject: "a new book is added to our library")
  end
end
