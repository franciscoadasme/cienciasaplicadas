class AddLocaleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :locale, :string
    add_reference :posts, :parent, references: :posts, index: true
    add_foreign_key :posts, :posts, column: :parent_id
  end
end
