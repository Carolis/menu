require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should have_many(:menu_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'functionality' do
    it 'can have multiple menu items' do
      menu = create(:menu, :with_menu_items)
      expect(menu.menu_items.count).to eq(2)
    end

    it 'destroys menu items when menu is destroyed' do
      menu = create(:menu, :with_menu_items)
      expect { menu.destroy }.to change(MenuItem, :count).by(-2)
    end
  end

  describe 'edge cases' do
    it 'can exist without menu items' do
      menu = create(:menu)
      expect(menu).to be_valid
      expect(menu.menu_items).to be_empty
    end
  end
end
