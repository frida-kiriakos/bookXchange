class ModifyBooks < ActiveRecord::Migration
  def change
  	change_column :books, :ISBN, :string
  	rename_column :books, :bbok_type, :book_type
  	add_column :books, :account_id, :integer
  	add_index :books, :title
  	add_index :books, :course
  	add_index :books, :author
  	add_index :books, :ISBN
  end
end
