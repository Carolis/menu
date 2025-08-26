require 'rails_helper'

RSpec.describe "Api::V1::MenuItems", type: :request do
  describe "GET /api/v1/menu_items" do
    context "with menu items" do
      let!(:restaurant) { create(:restaurant) }
      let!(:menu1) { restaurant.menus.create!(name: "lunch") }
      let!(:menu2) { restaurant.menus.create!(name: "dinner") }
      let!(:menu_item1) { create(:menu_item, name: "Burger") }
      let!(:menu_item2) { create(:menu_item, name: "Salad") }

      before do
        menu1.menu_items << menu_item1
        menu2.menu_items << menu_item2
        menu2.menu_items << menu_item1
      end

      it "returns all menu items with their menus" do
        get "/api/v1/menu_items"

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(2)

        burger_item = json.find { |item| item["name"] == "Burger" }
        expect(burger_item["menus"].length).to eq(2)

        salad_item = json.find { |item| item["name"] == "Salad" }
        expect(salad_item["menus"].length).to eq(1)
      end
    end

    context "with no menu items" do
      it "returns empty array" do
        get "/api/v1/menu_items"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "GET /api/v1/menu_items/:id" do
    let!(:restaurant) { create(:restaurant) }
    let!(:menu) { restaurant.menus.create!(name: "lunch") }
    let!(:menu_item) { create(:menu_item, name: "Burger") }

    before do
      menu.menu_items << menu_item
    end

    it "returns specific menu item with menus" do
      get "/api/v1/menu_items/#{menu_item.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(menu_item.id)
      expect(json["menus"].length).to eq(1)
      expect(json["menus"][0]["name"]).to eq("lunch")
    end

    it "returns 404 for non-existent menu item" do
      get "/api/v1/menu_items/999"

      expect(response).to have_http_status(404)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Menu item not found")
    end
  end
end
