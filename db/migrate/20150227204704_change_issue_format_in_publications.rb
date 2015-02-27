class ChangeIssueFormatInPublications < ActiveRecord::Migration
  def change
    change_column :publications, :issue, :string, limit: 10
  end
end
