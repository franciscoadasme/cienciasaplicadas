class AddManagedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :managed, :boolean, default: false
  end
end
