class AddResearchGateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :research_gate, :string
  end
end
