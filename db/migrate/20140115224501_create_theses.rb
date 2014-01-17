class CreateTheses < ActiveRecord::Migration
  def change
    create_table :theses do |t|
      t.string :title, null: false
      t.integer :issued, null: false
      t.string :institution, null: false
      t.text :abstract
      t.text :notes
      t.string :keywords
      t.belongs_to :user, index: true

      t.attachment :pdf_file

      t.index :title, unique: true

      t.timestamps
    end
  end
end
