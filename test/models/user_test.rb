# == Schema Information
#
# Table name: users
#
#  banner_content_type    :string(255)
#  banner_file_name       :string(255)
#  banner_file_size       :integer
#  banner_updated_at      :datetime
#  bio                    :text
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  first_name             :string(255)
#  headline               :string(255)
#  id                     :integer          not null, primary key
#  image_url              :string(255)
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string(255)
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  last_import_at         :datetime
#  last_name              :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  member                 :boolean          default(FALSE)
#  nickname               :string(255)
#  position_id            :integer
#  provider               :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :integer          default(0)
#  sign_in_count          :integer          default(0), not null
#  social_links           :text
#  uid                    :string(255)
#  updated_at             :datetime
#  view_count             :integer          default(0), not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
