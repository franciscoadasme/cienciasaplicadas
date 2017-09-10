class AddAbstractSectionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :abstract_section, :text
    add_column :events, :localized_abstract_section, :text
  end
end
