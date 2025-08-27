require 'rails_helper'

RSpec.describe "Api::V1::Restaurants", type: :request do
  describe "GET /api/v1/restaurants" do
    context "with no restaurants" do
      it "returns empty array" do
        get "/api/v1/restaurants"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "with restaurants" do
      let!(:restaurant1) { create(:restaurant, name: "Poppo's Cafe") }
      let!(:restaurant2) { create(:restaurant, name: "Casa del Poppo") }
      let!(:menu1) { restaurant1.menus.create!(name: "lunch") }
      let!(:menu2) { restaurant1.menus.create!(name: "dinner") }
      let!(:menu_item) { create(:menu_item, name: "Burger") }

      before do
        menu1.menu_items << menu_item
        menu2.menu_items << menu_item
      end

      it "returns all restaurants with nested menus and menu items" do
        get "/api/v1/restaurants"

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(2)

        poppos_cafe = json.find { |r| r["name"] == "Poppo's Cafe" }
        expect(poppos_cafe["menus"].length).to eq(2)

        lunch_menu = poppos_cafe["menus"].find { |m| m["name"] == "lunch" }
        expect(lunch_menu["menu_items"].length).to eq(1)
        expect(lunch_menu["menu_items"][0]["name"]).to eq("Burger")
      end
    end
  end

  describe "GET /api/v1/restaurants/:id" do
    let!(:restaurant) { create(:restaurant, name: "Test Restaurant") }
    let!(:menu) { restaurant.menus.create!(name: "lunch") }
    let!(:menu_items) { create_list(:menu_item, 2) }

    before do
      menu.menu_items = menu_items
    end

    it "returns specific restaurant with nested data" do
      get "/api/v1/restaurants/#{restaurant.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(restaurant.id)
      expect(json["name"]).to eq("Test Restaurant")
      expect(json["menus"].length).to eq(1)
      expect(json["menus"][0]["menu_items"].length).to eq(2)
    end

    it "returns 404 for non-existent restaurant" do
      get "/api/v1/restaurants/999"

      expect(response).to have_http_status(404)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Restaurant not found")
    end
  end

  describe "POST /api/v1/restaurants" do
    it "creates a new restaurant" do
      post "/api/v1/restaurants", params: {
        restaurant: { name: "New Restaurant" }
      }

      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("New Restaurant")
    end

    it "returns errors for invalid data" do
      post "/api/v1/restaurants", params: {
        restaurant: { name: "" }
      }

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Name can't be blank")
    end
  end
end
