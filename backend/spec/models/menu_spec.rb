require 'rails_helper'

RSpec.describe Menu, type: :model do
  subject { build(:menu) }
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_item_assignments).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_item_assignments) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'uniqueness validation' do
    let(:restaurant) { create(:restaurant) }

    it 'validates uniqueness of name within restaurant scope' do
      restaurant.menus.create!(name: "lunch")
      duplicate_menu = restaurant.menus.build(name: "lunch")
      expect(duplicate_menu).to_not be_valid
    end

    it 'allows same menu name across different restaurants' do
      other_restaurant = create(:restaurant, name: "Other Restaurant")
      restaurant.menus.create!(name: "lunch")
      other_menu = other_restaurant.menus.build(name: "lunch")
      expect(other_menu).to be_valid
    end
  end

  describe 'menu item relationships' do
    let(:restaurant) { create(:restaurant) }
    let(:menu) { restaurant.menus.create!(name: "lunch") }
    let(:burger) { create(:menu_item, name: "Burger") }
    let(:salad) { create(:menu_item, name: "Salad") }

    it 'can have multiple menu items assigned' do
      menu.menu_items << [ burger, salad ]
      expect(menu.menu_items.count).to eq(2)
      expect(menu.menu_items).to include(burger, salad)
    end

    it 'can share menu items with other menus of same restaurant' do
      dinner_menu = restaurant.menus.create!(name: "dinner")
      menu.menu_items << burger
      dinner_menu.menu_items << burger

      expect(burger.menus.count).to eq(2)
      expect(burger.menus).to include(menu, dinner_menu)
    end
  end
end
