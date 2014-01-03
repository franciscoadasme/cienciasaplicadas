class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.string :name, null: false
      t.string :abbr
      t.string :website_url
      t.float :impact_factor

      t.index :name, unique: true
      t.index :abbr, unique: true

      t.timestamps
    end
  end
end
