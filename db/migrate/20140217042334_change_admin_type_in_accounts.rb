class ChangeAdminTypeInAccounts < ActiveRecord::Migration
  def change
  	change_column :accounts, :admin, :bool
  end
end
