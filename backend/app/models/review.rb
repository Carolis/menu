class Review < ApplicationRecord
  belongs_to :restaurant

  validates :restaurant_id, presence: true
  validates :reviewer_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :reviewer_email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, allow_blank: true, length: { maximum: 500 }

  scope :by_rating, ->(rating) { where(rating: rating) }
  scope :recent, -> { order(created_at: :desc) }
end
