require 'rails_helper'

RSpec.describe RestaurantImportService, type: :service do
  let(:json_file_path) { Rails.root.join('spec', 'fixtures', 'restaurant_data.json') }
  let(:json_data) { JSON.parse(File.read(json_file_path)) }
  let(:service) { RestaurantImportService.new }

  before do
    MenuItemAssignment.destroy_all
    MenuItem.destroy_all
    Menu.destroy_all
    Restaurant.destroy_all
  end

  describe '#import' do
    context 'with valid JSON data' do
      it 'imports restaurants, menus, and menu items' do
        expect { service.import(json_data) }.to change(Restaurant, :count).by(2)
          .and change(Menu, :count).by(4)
          .and change(MenuItem, :count).by(6)
      end

      it 'returns success result with logs' do
        result = service.import(json_data)

        expect(result[:success]).to be true
        expect(result[:logs]).to be_an(Array)
        expect(result[:logs].count).to be > 0
        expect(result[:summary]).to include(:restaurants_created, :menus_created, :menu_items_created)
      end

      it 'handles duplicate menu item names correctly' do
        service.import(json_data)

        burger_items = MenuItem.where(name: 'Burger')
        expect(burger_items.count).to eq(1)

        burger = burger_items.first
        expect(burger.menus.count).to be >= 2
      end

      it 'handles inconsistent field names (menu_items vs dishes)' do
        service.import(json_data)

        casa_restaurant = Restaurant.find_by(name: 'Casa del Poppo')
        lunch_menu = casa_restaurant.menus.find_by(name: 'lunch')

        expect(lunch_menu.menu_items.pluck(:name)).to include('Chicken Wings', 'Burger')
      end

      it 'logs duplicate entries within same menu' do
        result = service.import(json_data)

        duplicate_logs = result[:logs].select { |log| log[:type] == 'duplicate' }
        expect(duplicate_logs).not_to be_empty
      end
    end

    context 'with invalid JSON data' do
      it 'handles missing restaurant names' do
        invalid_data = {
          'restaurants' => [
            { 'menus' => [] }
          ]
        }

        result = service.import(invalid_data)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(/Restaurant name is required/)
      end

      it 'handles invalid price data' do
        invalid_data = {
          'restaurants' => [ {
            'name' => 'Test Restaurant',
            'menus' => [ {
              'name' => 'test menu',
              'menu_items' => [ { 'name' => 'Test Item', 'price' => 'invalid' } ]
            } ]
          } ]
        }

        result = service.import(invalid_data)
        expect(result[:success]).to be false
        expect(result[:errors]).to include(/Invalid price for Test Item/)
      end
    end
  end

  describe '#import_from_file' do
    it 'imports from file path' do
      result = service.import_from_file(json_file_path.to_s)
      expect(result[:success]).to be true
    end

    it 'handles file not found' do
      result = service.import_from_file('non_existent.json')
      expect(result[:success]).to be false
      expect(result[:errors]).to include(/File not found/)
    end
  end
end
