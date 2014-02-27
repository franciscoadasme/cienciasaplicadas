class AddBannerToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.attachment :banner
    end
  end
end
