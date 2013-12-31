class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.integer :author_id
      t.integer :edited_by_id
      t.text :body
      t.boolean :published, default: false

      t.index :slug, unique: true

      t.timestamps
    end
  end
end
