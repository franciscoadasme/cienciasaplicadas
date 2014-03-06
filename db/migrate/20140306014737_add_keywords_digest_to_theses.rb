class AddKeywordsDigestToTheses < ActiveRecord::Migration
  def change
    add_column :theses, :keywords_digest, :string
  end
end
