class AddLocaleToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :locale, :string
  end
end
