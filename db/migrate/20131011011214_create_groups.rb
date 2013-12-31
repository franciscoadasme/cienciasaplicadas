class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :abbr
      t.string :logo
      t.string :email
      t.text :bio

      t.timestamps

      t.index :name, unique: true
      t.index :abbr, unique: true
      t.index :email, unique: true
    end
  end
end
