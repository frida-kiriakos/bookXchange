class BookObserver < ActiveRecord::Observer
	def after_create(book)		
		NotificationsMailer.book_added_email(book).deliver
	end
end