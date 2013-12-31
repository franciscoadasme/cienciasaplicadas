class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :doi
      t.string :url
      t.string :journal
      t.integer :volume
      t.integer :issue
      t.integer :start_page
      t.integer :end_page
      t.integer :month
      t.integer :year
      t.string :title, limit: 1000
      t.string :identifier

      t.index :doi, unique: true
      t.index :identifier, unique: true
      t.index [ :volume, :start_page ], unique: true
      t.index :title, unique: true

      t.timestamps
    end
  end
end
