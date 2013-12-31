class AddTrashedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :trashed, :boolean, default: false
  end
end
