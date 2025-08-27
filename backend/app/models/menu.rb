class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_item_assignments, dependent: :destroy
  has_many :menu_items, through: :menu_item_assignments

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }
end
