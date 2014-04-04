class AddCreditToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :credit, :integer, :default => 0

    # set default value for book_type to be 0, added
    change_column :books, :book_type, :integer, :default => 0
  end
end
