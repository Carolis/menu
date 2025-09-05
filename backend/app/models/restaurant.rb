class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, through: :menus

  validates :name, presence: true, uniqueness: true

  scope :search_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
end
