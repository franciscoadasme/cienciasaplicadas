class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.belongs_to :user, index: true
      t.belongs_to :publication, index: true

      t.index [ :name, :publication_id ], unique: true

      t.timestamps
    end
  end
end
