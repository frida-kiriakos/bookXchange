class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :edition
      t.integer :ISBN
      t.string :course
      t.integer :bbok_type

      t.timestamps
    end
  end
end
