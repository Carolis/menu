class MenuItem < ApplicationRecord
  has_many :menu_item_assignments, dependent: :destroy
  has_many :menus, through: :menu_item_assignments
  has_many :restaurants, through: :menus

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
