class CreateExternalUsers < ActiveRecord::Migration
  def change
    create_table :external_users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :institution, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.string :website_url

      t.index [ :first_name, :last_name ], unique: true

      t.timestamps
    end
  end
end
