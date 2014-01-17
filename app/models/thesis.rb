# == Schema Information
#
# Table name: theses
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  issued                :integer          not null
#  institution           :string(255)      not null
#  abstract              :text
#  notes                 :text
#  keywords              :string(255)
#  user_id               :integer
#  pdf_file_file_name    :string(255)
#  pdf_file_content_type :string(255)
#  pdf_file_file_size    :integer
#  pdf_file_updated_at   :datetime
#  created_at            :datetime
#  updated_at            :datetime
#

class Thesis < ActiveRecord::Base
  belongs_to :user
  has_attached_file :pdf_file, styles: { thumb: [ '200', :jpg ] },
                      convert_options: { all: '-colorspace RGB -flatten -density 300 -quality 100' }

  VALID_NAME_REGEX = /\A[[:alpha:] ,\.'-]+\Z/i
  validates :title, presence: true,
                      format: { with: VALID_NAME_REGEX }
  validates :issued, presence: true,
                 numericality: { only_integer: true,
                                 greater_than: 1950 }
  validates :institution, presence: true,
                            format: { with: VALID_NAME_REGEX }
  validates :user, presence: true
  validates_attachment :pdf_file, presence: { message: 'No file was selected' },
                              content_type: { content_type: 'application/pdf',
                                                   message: 'Only PDFs are allowed' },
                                      size: { in: 0..10.megabytes }

  def keyword_list
    keywords.split /\s*,\s*/
  end
end
