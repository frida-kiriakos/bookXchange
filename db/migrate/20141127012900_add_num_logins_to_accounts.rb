class AddNumLoginsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :num_logins, :integer, :default => 0
  end
end
