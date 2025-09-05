class MenuItem < ApplicationRecord
  has_many :menu_item_assignments, dependent: :destroy
  has_many :menus, through: :menu_item_assignments
  has_many :restaurants, through: :menus

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :search_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :price_range, ->(min_price, max_price) {
    result = all
    result = result.where("price >= ?", min_price) if min_price.present?
    result = result.where("price <= ?", max_price) if max_price.present?
    result
  }
  scope :by_restaurant, ->(restaurant_id) { joins(:restaurants).where(restaurants: { id: restaurant_id }) if restaurant_id.present? }
  scope :by_menu, ->(menu_id) { joins(:menus).where(menus: { id: menu_id }) if menu_id.present? }
end
