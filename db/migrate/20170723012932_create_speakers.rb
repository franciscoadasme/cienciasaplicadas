class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :institution, null: false
      t.string :website_url
      t.attachment :photo

      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
