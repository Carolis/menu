require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :controller do
  let!(:restaurant) { create(:restaurant) }
  let!(:review) { create(:review, restaurant: restaurant) }

  describe "GET #index" do
    it "returns reviews for a restaurant" do
      get :index, params: { restaurant_id: restaurant.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end

    it "returns 404 when restaurant not found" do
      get :index, params: { restaurant_id: 999999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a specific review" do
      get :show, params: { restaurant_id: restaurant.id, id: review.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(review.id)
    end

    it "returns 404 when review not found" do
      get :show, params: { restaurant_id: restaurant.id, id: 999999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        restaurant_id: restaurant.id,
        review: {
          reviewer_name: "Jane Doe",
          reviewer_email: "jane@example.com",
          rating: 4,
          comment: "Good experience"
        }
      }
    end

    it "creates a new review with valid params" do
      expect {
        post :create, params: valid_params
      }.to change(Review, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors with invalid params" do
      invalid_params = valid_params.dup
      invalid_params[:review][:rating] = 6
      post :create, params: invalid_params
      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe "PATCH #update" do
    it "updates review with valid params" do
      patch :update, params: {
        restaurant_id: restaurant.id,
        id: review.id,
        review: { comment: "Updated comment" }
      }
      expect(response).to have_http_status(:ok)
      review.reload
      expect(review.comment).to eq("Updated comment")
    end

    it "returns errors with invalid params" do
      patch :update, params: {
        restaurant_id: restaurant.id,
        id: review.id,
        review: { rating: 0 }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the review" do
      expect {
        delete :destroy, params: { restaurant_id: restaurant.id, id: review.id }
      }.to change(Review, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end