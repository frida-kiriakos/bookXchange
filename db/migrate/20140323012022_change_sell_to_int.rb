class ChangeSellToInt < ActiveRecord::Migration
  def change
  	change_column :books, :sell, :integer
  end
end
