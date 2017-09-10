class AddAbstractTemplateToEvents < ActiveRecord::Migration
  def change
    add_attachment :events, :abstract_template
  end
end
