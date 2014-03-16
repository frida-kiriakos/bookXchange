class BooksController < ApplicationController
	before_action :signed_in_user, only: [:new, :create]

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
  	  flash[:success] = "Book deleted successfully"
  	  redirect_to books_url
  	end
  end

private
	def book_params
		params.require(:book).permit(:title, :author, :ISBN, :edition, :course, :book_type)
	end

end
