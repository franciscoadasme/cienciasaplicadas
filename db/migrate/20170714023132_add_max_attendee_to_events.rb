class AddMaxAttendeeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :max_attendee, :integer
  end
end
