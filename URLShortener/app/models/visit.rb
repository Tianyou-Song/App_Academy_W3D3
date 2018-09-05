# == Schema Information
#
# Table name: visits
#
#  id               :bigint(8)        not null, primary key
#  shortened_url_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  validates :shortened_url_id, :user_id, presence: true
  
  def self.record_visit!(user,shortened_url)
    Visit.new(shortened_url_id: shortened_url.id, user_id: user.id)
  end
  
  belongs_to :user,
  class_name: :User,
  foreign_key: :user_id,
  primary_key: :id
  
  belongs_to :shortened_url,
  class_name: :ShortenedUrl,
  foreign_key: :shortened_url_id,
  primary_key: :id
end
