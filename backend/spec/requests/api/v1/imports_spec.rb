require 'rails_helper'

RSpec.describe "Api::V1::Imports", type: :request do
  let(:valid_json_data) do
    {
      "restaurants" => [
        {
          "name" => "Test Restaurant",
          "menus" => [
            {
              "name" => "lunch",
              "menu_items" => [
                { "name" => "Test Burger", "price" => 10.00 }
              ]
            }
          ]
        }
      ]
    }
  end

  before do
    MenuItemAssignment.destroy_all
    MenuItem.destroy_all
    Menu.destroy_all
    Restaurant.destroy_all
  end

  describe "POST /api/v1/import/restaurants" do
    context "with valid JSON data" do
      it "imports restaurants successfully" do
        expect {
          post "/api/v1/import/restaurants", params: { data: valid_json_data }
        }.to change(Restaurant, :count).by(1)
          .and change(Menu, :count).by(1)
          .and change(MenuItem, :count).by(1)

        expect(response).to have_http_status(201)
        json = JSON.parse(response.body)
        expect(json["success"]).to be true
        expect(json["logs"]).to be_an(Array)
        expect(json["summary"]["restaurants_created"]).to eq(1)
      end

      it "returns detailed logs" do
        post "/api/v1/import/restaurants", params: { data: valid_json_data }

        json = JSON.parse(response.body)
        expect(json["logs"].first).to include("type", "message", "timestamp")
      end
    end

    context "with file upload" do
      let(:temp_file) do
        file = Tempfile.new([ 'test', '.json' ])
        file.write(valid_json_data.to_json)
        file.rewind
        file
      end

      it "imports from uploaded file" do
        uploaded_file = Rack::Test::UploadedFile.new(temp_file, "application/json")

        expect {
          post "/api/v1/import/restaurants", params: { file: uploaded_file }
        }.to change(Restaurant, :count).by(1)

        expect(response).to have_http_status(201)
        temp_file.close
        temp_file.unlink
      end
    end

    context "with invalid data" do
      it "returns error for missing data" do
        post "/api/v1/import/restaurants"

        expect(response).to have_http_status(400)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("No file or data provided")
      end

      it "handles invalid JSON" do
        post "/api/v1/import/restaurants", params: { data: "invalid json" }

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
      end

      it "handles validation errors" do
        invalid_data = { "restaurants" => [ { "menus" => [] } ] }

        post "/api/v1/import/restaurants", params: { data: invalid_data }

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json["success"]).to be false
        expect(json["errors"]).to include(/Restaurant name is required/)
      end
    end
  end
end
