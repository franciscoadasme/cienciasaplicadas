class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :leader_id, index: true
      t.integer :start_year
      t.integer :end_year
      t.string :source
      t.string :identifier
      t.text :description
      t.string :image_url

      t.index :title, unique: true
      t.index [ :title, :identifier ], unique: true

      t.timestamps
    end
  end
end
