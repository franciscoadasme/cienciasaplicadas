class AddRegistrationEnabledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_enabled, :boolean, default: false
  end
end
