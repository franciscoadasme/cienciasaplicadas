class RenameSignatureInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :signature, :social_links
  end
end
