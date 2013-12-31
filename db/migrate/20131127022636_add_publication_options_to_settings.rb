class AddPublicationOptionsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :autolink_on_import, :boolean, default: true
    add_column :settings, :display_author_name, :boolean, default: false
  end
end
