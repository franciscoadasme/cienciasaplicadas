class AddIncludeLastnameToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :include_lastname, :boolean, default: false
  end
end
