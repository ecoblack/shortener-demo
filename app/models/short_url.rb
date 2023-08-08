class ShortUrl < ApplicationRecord
  belongs_to :user, optional: true

  validates :original_url, presence: true
  validates :code, presence: true, uniqueness: true
end
