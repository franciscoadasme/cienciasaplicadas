class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :email, null: false
      t.string :name
      t.boolean :accepted
      t.references :event, index: true, foreign_key: true

      t.index [:event_id, :email], unique: true

      t.timestamps null: false
    end
  end
end
