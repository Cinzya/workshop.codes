class Favorite < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates_uniqueness_of :user_id, scope: %i[post_id]
end
