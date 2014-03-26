class Book < ActiveRecord::Base
	belongs_to :account
	validates :title, presence: true
	validates :author, presence: true

	searchable do
    text :title, :author    
  end
end
