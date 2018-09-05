# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'SecureRandom'

class ShortenedUrl < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true
  validates :long_url, presence: true
  
  def self.random_code
    random_str = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: random_str)
      random_str = SecureRandom.urlsafe_base64
    end
    random_str
  end
  
  def self.create!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.new(long_url: long_url, short_url: short_url, user_id:user.id)
  end 
  
  belongs_to :submitter,
  class_name: :User, 
  foreign_key: :user_id,
  primary_key: :id
  
  has_many :visits,
  class_name: :Visit,
  foreign_key: :shortened_url_id,
  primary_key: :id
  
  has_many :visitors,
  through: :visits,
  source: :user
  
  def num_clicks 
    self.visits.count
  end 
  
  def num_uniques
    self.visitors.uniq.count
  end 
  
  def num_recent_uniques 
    self.visits.select(:user_id).where('created_at > :a', a: 10.minutes.ago).distinct.count
  end 
end 
