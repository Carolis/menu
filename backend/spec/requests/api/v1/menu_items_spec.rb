require 'rails_helper'

RSpec.describe "Api::V1::MenuItems", type: :request do
  let!(:menu) { Menu.create!(name: "Lunch Menu") }
  let!(:menu_item) { menu.menu_items.create!(name: "Burger", price: 9.00) }

  describe "GET /api/v1/menu_items" do
    it "returns all menu items with their menu" do
      get "/api/v1/menu_items"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq("Burger")
      expect(json[0]["price"]).to eq("9.0")
      expect(json[0]["menu"]["name"]).to eq("Lunch Menu")
    end
  end

  describe "GET /api/v1/menu_items/:id" do
    it "returns specific menu item with menu" do
      get "/api/v1/menu_items/#{menu_item.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Burger")
      expect(json["menu"]["name"]).to eq("Lunch Menu")
    end
  end
end
