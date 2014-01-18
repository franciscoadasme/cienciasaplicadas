class ChangeDefaultsOfSettings < ActiveRecord::Migration
  def up
    change_table :settings do |t|
      t.change :include_lastname, :boolean, default: true
      t.change :display_author_name, :boolean, default: true
    end
  end

  def down
    change_table :settings do |t|
      t.change :include_lastname, :boolean, default: false
      t.change :display_author_name, :boolean, default: false
    end
  end
end
