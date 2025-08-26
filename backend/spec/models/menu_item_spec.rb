require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe 'price validation' do
    it 'rejects zero price' do
      menu_item = build(:menu_item, price: 0)
      expect(menu_item).to_not be_valid
    end

    it 'rejects negative price' do
      menu_item = build(:menu_item, price: -1)
      expect(menu_item).to_not be_valid
    end

    it 'accepts positive price' do
      menu_item = build(:menu_item, price: 9.99)
      expect(menu_item).to be_valid
    end
  end

  describe 'edge cases' do
    it 'handles very high prices' do
      menu_item = create(:menu_item, price: 999.99)
      expect(menu_item.price).to eq(999.99)
    end
  end
end
