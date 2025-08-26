require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }
  describe 'associations' do
    it { should have_many(:menus).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menus) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'functionality' do
    let(:restaurant) { create(:restaurant) }

    it 'can have multiple menus' do
      lunch_menu = restaurant.menus.create!(name: "lunch")
      dinner_menu = restaurant.menus.create!(name: "dinner")

      expect(restaurant.menus.count).to eq(2)
      expect(restaurant.menus).to include(lunch_menu, dinner_menu)
    end

    it 'can access menu items through menus' do
      menu = restaurant.menus.create!(name: "lunch")
      menu_item = create(:menu_item, name: "Burger")
      menu.menu_items << menu_item

      expect(restaurant.menu_items).to include(menu_item)
    end

    it 'destroys associated menus when destroyed' do
      restaurant.menus.create!(name: "lunch")
      expect { restaurant.destroy }.to change(Menu, :count).by(-1)
    end
  end
end
