class AddAbstractDeadlineToEvents < ActiveRecord::Migration
  def change
    add_column :events, :abstract_deadline, :date
  end
end
