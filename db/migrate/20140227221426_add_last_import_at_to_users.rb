class AddLastImportAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_import_at, :datetime
  end
end
