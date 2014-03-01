class AddBannerToPages < ActiveRecord::Migration
  def change
    change_table :pages do |t|
      t.attachment :banner
    end
  end
end
