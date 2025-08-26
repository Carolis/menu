require 'rails_helper'

RSpec.describe "Api::V1::MenuItems", type: :request do
  describe "GET /api/v1/menu_items" do
    context "with menu items" do
      let!(:menu_items) { create_list(:menu_item, 3) }

      it "returns all menu items with their menus" do
        get "/api/v1/menu_items"

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(3)

        json.each do |item|
          expect(item["menu"]).to be_present
          expect(item["menu"]["name"]).to be_present
        end
      end
    end
  end

  describe "GET /api/v1/menu_items/:id" do
    let!(:menu_item) { create(:menu_item) }

    it "returns specific menu item with menu" do
      get "/api/v1/menu_items/#{menu_item.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(menu_item.id)
      expect(json["menu"]["id"]).to eq(menu_item.menu.id)
    end

    it "returns 404 for non-existent menu item" do
      get "/api/v1/menu_items/999"

      expect(response).to have_http_status(404)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Menu item not found")
    end
  end
end
