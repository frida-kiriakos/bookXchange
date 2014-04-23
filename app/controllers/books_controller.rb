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
    # search using eastic search
    # @books = Book.search(params[:book]).records.where(book_type: Book::TYPES[:added])
    # run Book.reindex on console when:
    # when you install or upgrade searchkick
    # change the searchkick method
    
    @books = Book.search params[:book], where: {book_type: Book::TYPES[:added]}, page: params[:page], per_page: 20

    #  search using sunspot
    # @books = Book.search do       
    #   with :book_type, Book::TYPES[:added]
    #   fulltext params[:book]
    #   paginate :page => params[:page]
    # end.results
  end

  def buy
    @book = Book.find(params[:id])
    if request.get?
      if @book.book_type == Book::TYPES[:sold]
        flash.now[:warning] = "The book is not available anymore"
        render 'show'
      end
    elsif request.post?
      # logger.info "======= #{params[:transaction][:from]}"
      transaction = current_user.transactions.build(from: params[:transaction][:from], to: @book.paypal_account, amount: @book.amount, book_id: @book.id)
      if transaction.save
        @book.update_attribute(:book_type, Book::TYPES[:sold] )
        flash[:success] = "Transaction performed successfully "
        redirect_to @book
      else
        flash[:error] = "an error occurred"
      end
    end
  end

  def get_book
    @book = Book.find(params[:id])
    if @book.book_type == Book::TYPES[:exchanged]
      flash.now[:warning] = "The book is not available anymore"
    else
      if current_user.credit > 0
        @book.update_attribute(:book_type, Book::TYPES[:exchanged] )
        current_user.update_column(:credit, current_user.credit - 1)
        flash.now[:success] = "The book will be sent to you at your mailing address"
      else
        flash.now[:warning] = "You do not have enough credit to exchange the book, please add books for exchange to earn credit"
      end
    end
    render 'show'
  end

private
	def book_params
		params.require(:book).permit(:title, :author, :ISBN, :edition, :course, :book_type, :sell, :amount, :paypal_account)
	end

end
