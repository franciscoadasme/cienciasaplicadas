class AddLocalizedDescriptionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :localized_description, :text
  end
end
