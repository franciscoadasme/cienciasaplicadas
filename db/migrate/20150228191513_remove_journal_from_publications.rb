class RemoveJournalFromPublications < ActiveRecord::Migration
  def change
    remove_column :publications, :journal, :string
  end
end
