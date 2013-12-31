class DropUsers < ActiveRecord::Migration
  def up
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :nickname
      t.string :email
      t.string :image_url
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.string :first_name
      t.string :last_name
      t.string :remember_token

      t.integer :role, default: 0, limit: 1

      t.timestamps
    end
  end
end
