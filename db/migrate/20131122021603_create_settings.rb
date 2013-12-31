class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :update_attributes_by_provider, default: true
      t.boolean :update_nickname_by_provider, default: false
      t.boolean :update_image_by_provider, default: true
      t.boolean :show_contact_page, default: true
      t.boolean :deliver_notification_by_email, default: true

      t.belongs_to :user, index: { unique: true }
    end
  end
end
