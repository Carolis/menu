class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_item_assignments, dependent: :destroy
  has_many :menu_items, through: :menu_item_assignments

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }

  scope :search_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :by_restaurant, ->(restaurant_id) { where(restaurant_id: restaurant_id) if restaurant_id.present? }
end
