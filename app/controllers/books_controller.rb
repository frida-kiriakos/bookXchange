class BooksController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :get_book, :buy]

	def index
		@books = Book.paginate(page: params[:page]) 		
	end

	def show
		@book = Book.find(params[:id])		
	end

  def new
  	@book = current_user.books.build()
  end

  def create
  	@book = current_user.books.build(book_params)

  	if @book.save
      if @book.sell == 0
        current_user.update_column(:credit, current_user.credit + 1)
      end
      flash[:success] = "Book added successfully"
      redirect_to @book
    else
      render 'new'
    end    

  end

  def edit
  	@book = Book.find(params[:id])  	
  end

  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		flash[:success] = "Book information was successfully updated."
  		redirect_to @book
  	else
  		render 'edit'
  	end  	
  end

  def destroy
  	@book = Book.find(params[:id]) 
  	if @book.destroy
      current_user.update_column(:credit, current_user.credit - 1)
  	  flash[:success] = "Book deleted successfully"
  	  redirect_to books_url
  	end
  end

  def search
    @books = Book.search do       
      with :book_type, Book::TYPES[:added]
      fulltext params[:book]
      paginate :page => params[:page]
    end.results
  end

  def buy    
  end

  def get_book
    @book = Book.find(params[:id])
    if current_user.credit > 0
      @book.update_attribute(:book_type, Book::TYPES[:exchanged] )
      current_user.update_column(:credit, current_user.credit - 1)
      flash.now[:success] = "The book will be sent to you at your mailing address"
    else
      flash.now[:warning] = "You do not have enough credit to exchange the book, please add books for exchange to earn credit"
    end
    render 'show'
  end

private
	def book_params
		params.require(:book).permit(:title, :author, :ISBN, :edition, :course, :book_type, :sell, :amount, :paypal_account)
	end

end
