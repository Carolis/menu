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
      let!(:menu1) { create(:menu, :with_menu_items) }
      let!(:menu2) { create(:menu) }

      it "returns all menus with menu items" do
        get "/api/v1/menus"

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(2)

        menu_with_items = json.find { |m| m["id"] == menu1.id }
        expect(menu_with_items["menu_items"].length).to eq(2)

        menu_without_items = json.find { |m| m["id"] == menu2.id }
        expect(menu_without_items["menu_items"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/menus/:id" do
    let!(:menu) { create(:menu, :with_menu_items) }

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
