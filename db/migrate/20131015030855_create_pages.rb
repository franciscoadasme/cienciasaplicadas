class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :tagline
      t.text :body
      t.integer :owner_id
      t.integer :author_id
      t.integer :edited_by_id
      t.boolean :published, default: false

      t.timestamps

      t.index [ :owner_id, :tagline ], unique: true
    end
  end
end
