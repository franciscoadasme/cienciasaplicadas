class AddInstitutionToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :institution, :string, limit: 255
  end
end
