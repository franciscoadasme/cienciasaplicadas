class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.attachment :photo
      t.string :caption
      t.date :taken_on

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
