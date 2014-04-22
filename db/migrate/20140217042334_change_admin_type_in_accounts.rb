class ChangeAdminTypeInAccounts < ActiveRecord::Migration
  def change
  	change_column :accounts, :admin, 'boolean USING CAST(admin AS boolean)'
  end
end
