class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.string :location, null: false
      t.text :description
      t.string :event_type, null: false
      t.string :promoter
      t.attachment :picture

      t.index [ :name, :start_date ], unique: true

      t.timestamps
    end
  end
end
