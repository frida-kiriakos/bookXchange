class AddSellToBooks < ActiveRecord::Migration
  def change
    add_column :books, :sell, :boolean
    add_column :books, :amount, :integer
    add_column :books, :paypal_account, :string
  end
end
