class Book < ActiveRecord::Base
	belongs_to :account
	has_one :transaction
	validates :title, presence: true
	validates :author, presence: true

	TYPES = { added: 0, exchanged: 1, sold: 2 }

	searchable do
    text :title, :author, :ISBN, :course
    integer :book_type    
  end
end
