class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.belongs_to :author, index: true, foreign_key: true
      t.attachment :document
      t.belongs_to :event, index: true, foreign_key: true
      t.string :submitted_at
      t.string :title, limit: 255
      t.string :token
      t.datetime :token_created_at
      t.timestamps

      t.index [:event_id, :author_id], unique: true
    end
  end
end
