class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :education
      t.integer :admin
      t.string :address
      t.string :password_digest

      t.timestamps
    end
  end
end
