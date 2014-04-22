class ChangeSellToInt < ActiveRecord::Migration
  def change
  	change_column :books, :sell, 'integer USING CAST(sell AS integer)'
  end
end
