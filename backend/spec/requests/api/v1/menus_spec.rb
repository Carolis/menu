require 'rails_helper'

RSpec.describe "Api::V1::Menus", type: :request do
  describe "GET /api/v1/menus" do
    context "with no menus" do
      it "returns empty array" do
        get "/api/v1/menus"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "with menus" do
      let!(:restaurant) { create(:restaurant) }
      let!(:menu1) { restaurant.menus.create!(name: "lunch") }
      let!(:menu2) { restaurant.menus.create!(name: "dinner") }
      let!(:burger) { create(:menu_item, name: "Burger") }
      let!(:salad) { create(:menu_item, name: "Salad") }

      before do
        menu1.menu_items << [ burger, salad ]
        menu2.menu_items << burger
      end

      it "returns all menus with menu items" do
        get "/api/v1/menus"

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(2)

        lunch_menu = json.find { |m| m["name"] == "lunch" }
        expect(lunch_menu["menu_items"].length).to eq(2)

        dinner_menu = json.find { |m| m["name"] == "dinner" }
        expect(dinner_menu["menu_items"].length).to eq(1)
        expect(dinner_menu["menu_items"][0]["name"]).to eq("Burger")
      end
    end
  end

  describe "GET /api/v1/menus/:id" do
    let!(:restaurant) { create(:restaurant) }
    let!(:menu) { restaurant.menus.create!(name: "lunch") }
    let!(:menu_items) { create_list(:menu_item, 2) }

    before do
      menu.menu_items = menu_items
    end

    it "returns specific menu with menu items" do
      get "/api/v1/menus/#{menu.id}"

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(menu.id)
      expect(json["menu_items"].length).to eq(2)
    end

    it "returns 404 for non-existent menu" do
      get "/api/v1/menus/999"

      expect(response).to have_http_status(404)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Menu not found")
    end
  end
end
