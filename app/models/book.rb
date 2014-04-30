class Book < ActiveRecord::Base
	# search using eastic search
	# include Elasticsearch::Model
 #  include Elasticsearch::Model::Callbacks
  
  # search using searchkick
  searchkick
  
	belongs_to :account
	has_one :transaction
	validates :title, presence: true
	validates :author, presence: true
	validates :sell, presence: true
	validates :amount, length: {maximum: 11} #, numericality: {less_than_or_equal_to: 200}

	TYPES = { added: 0, exchanged: 1, sold: 2 }
	SELL_TYPES = {exchange: 0, sell: 1}


# search using sunspot
	# searchable do
 #    text :title, :author, :ISBN, :course
 #    integer :book_type    
 #  end
end
