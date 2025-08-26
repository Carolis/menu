require 'rails_helper'

RSpec.describe MenuItemAssignment, type: :model do
  subject { build(:menu_item_assignment) }
  describe 'associations' do
    it { should belong_to(:menu) }
    it { should belong_to(:menu_item) }
  end

  describe 'validations' do
    let(:restaurant) { create(:restaurant) }
    let(:menu) { restaurant.menus.create!(name: "lunch") }
    let(:menu_item) { create(:menu_item, name: "Burger") }

    it 'prevents duplicate assignments of same menu item to same menu' do
      MenuItemAssignment.create!(menu: menu, menu_item: menu_item)
      duplicate = MenuItemAssignment.build(menu: menu, menu_item: menu_item)
      expect(duplicate).to_not be_valid
    end

    it 'allows same menu item on different menus' do
      other_menu = restaurant.menus.create!(name: "dinner")
      MenuItemAssignment.create!(menu: menu, menu_item: menu_item)
      other_assignment = MenuItemAssignment.build(menu: other_menu, menu_item: menu_item)
      expect(other_assignment).to be_valid
    end
  end
end
