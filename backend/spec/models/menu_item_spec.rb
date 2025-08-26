require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  subject { build(:menu_item) }

  describe 'associations' do
    it { should have_many(:menu_item_assignments).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_item_assignments) }
    it { should have_many(:restaurants).through(:menus) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'global uniqueness constraint' do
    it 'prevents duplicate menu item names globally' do
      create(:menu_item, name: "Burger")
      duplicate = build(:menu_item, name: "Burger", price: 15.00)
      expect(duplicate).to_not be_valid
    end

    it 'allows different names' do
      create(:menu_item, name: "Burger")
      different_item = build(:menu_item, name: "Pizza")
      expect(different_item).to be_valid
    end
  end

  describe 'many-to-many relationships' do
    let(:restaurant) { create(:restaurant) }
    let(:lunch_menu) { restaurant.menus.create!(name: "lunch") }
    let(:dinner_menu) { restaurant.menus.create!(name: "dinner") }
    let(:burger) { create(:menu_item, name: "Burger") }

    it 'can be on multiple menus of the same restaurant' do
      lunch_menu.menu_items << burger
      dinner_menu.menu_items << burger

      expect(burger.menus.count).to eq(2)
      expect(burger.menus).to include(lunch_menu, dinner_menu)
      expect(burger.restaurants).to include(restaurant)
    end

    it 'can have different prices on different menus via join table' do
      lunch_menu.menu_items << burger
      dinner_menu.menu_items << burger

      expect(burger.menu_item_assignments.count).to eq(2)
    end
  end
end
