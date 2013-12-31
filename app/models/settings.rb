# == Schema Information
#
# Table name: settings
#
#  id                            :integer          not null, primary key
#  update_attributes_by_provider :boolean          default(TRUE)
#  update_nickname_by_provider   :boolean          default(FALSE)
#  update_image_by_provider      :boolean          default(TRUE)
#  show_contact_page             :boolean          default(TRUE)
#  deliver_notification_by_email :boolean          default(TRUE)
#  user_id                       :integer
#  autolink_on_import            :boolean          default(TRUE)
#  display_author_name           :boolean          default(FALSE)
#  include_lastname              :boolean          default(FALSE)
#

class Settings < ActiveRecord::Base
  belongs_to :user

  def should_update_attributes?
    update_attributes_by_provider
  end

  def should_update_attribute? name
    case name
    when :nickname then update_nickname_by_provider
    when :image_url then update_image_by_provider
    else
      update_attributes?
    end
  end
end
