class AddSlugToThesis < ActiveRecord::Migration
  def change
    add_column :theses, :slug, :string
  end
end
