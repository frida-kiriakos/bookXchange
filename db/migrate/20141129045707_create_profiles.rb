class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :account
    	t.string :pages
    	t.string :ip_address
    	t.string :browser
    	t.string :operating_system
    	t.integer :access_time
      t.timestamps
    end
  end
end
