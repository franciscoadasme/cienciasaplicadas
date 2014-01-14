class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :institution
      t.string :email, null: false
      t.string :website_url

      t.index [ :first_name, :last_name ], unique: true
      t.index :email, unique: true

      t.timestamps
    end
  end
end