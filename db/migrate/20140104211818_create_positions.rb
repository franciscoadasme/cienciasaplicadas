class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
