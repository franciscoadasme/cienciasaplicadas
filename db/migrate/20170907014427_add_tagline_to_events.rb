class AddTaglineToEvents < ActiveRecord::Migration
  def change
    add_column :events, :tagline, :string, limit: 128
    add_index :events, :tagline, unique: true
  end
end
