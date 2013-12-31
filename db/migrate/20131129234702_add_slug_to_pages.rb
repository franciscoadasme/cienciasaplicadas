class AddSlugToPages < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string

    add_index :pages, [ :owner_id, :slug ], unique: true
  end
end
