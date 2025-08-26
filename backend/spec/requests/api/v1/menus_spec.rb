require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  let!(:menu) { Menu.create!(name: "Lunch Menu") }
  let!(:menu_item1) { menu.menu_items.create!(name: "Burger", price: 9.00) }
  let!(:menu_item2) { menu.menu_items.create!(name: "Salad", price: 5.00) }

  describe "GET /api/v1/menus" do
    it "returns all menus with menu items" do
      get "/api/v1/menus"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json.length).to eq(1)
      expect(json[0]["name"]).to eq("Lunch Menu")
      expect(json[0]["menu_items"].length).to eq(2)
    end
  end

  describe "GET /api/v1/menus/:id" do
    it "returns specific menu with menu items" do
      get "/api/v1/menus/#{menu.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Lunch Menu")
      expect(json["menu_items"]).to be_present
      expect(json["menu_items"].length).to eq(2)
    end
  end
end
