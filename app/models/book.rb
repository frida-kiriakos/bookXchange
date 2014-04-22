class Book < ActiveRecord::Base
	# search using eastic search
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
	belongs_to :account
	has_one :transaction
	validates :title, presence: true
	validates :author, presence: true

	TYPES = { added: 0, exchanged: 1, sold: 2 }


# search using sunspot
	# searchable do
 #    text :title, :author, :ISBN, :course
 #    integer :book_type    
 #  end
end
