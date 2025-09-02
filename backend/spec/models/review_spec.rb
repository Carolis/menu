require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "associations" do
    it { should belong_to(:restaurant) }
  end

  describe "validations" do
    subject { build(:review) }

    it { should validate_presence_of(:restaurant_id) }
    it { should validate_presence_of(:reviewer_name) }
    it { should validate_length_of(:reviewer_name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_length_of(:comment).is_at_most(500) }
    it { should allow_value("").for(:reviewer_email) }
    it { should allow_value("test@example.com").for(:reviewer_email) }
    it { should_not allow_value("invalid-email").for(:reviewer_email) }
  end

  describe "scopes" do
    let!(:restaurant) { create(:restaurant) }
    let!(:five_star) { create(:review, restaurant: restaurant, rating: 5) }
    let!(:four_star) { create(:review, restaurant: restaurant, rating: 4) }
    let!(:older_review) { create(:review, restaurant: restaurant, created_at: 1.day.ago) }

    describe ".by_rating" do
      it "filters reviews by rating" do
        expect(Review.by_rating(5)).to include(five_star)
        expect(Review.by_rating(5)).not_to include(four_star)
      end
    end

    describe ".recent" do
      it "orders reviews by most recent first" do
        expect(Review.recent.first).to eq(four_star)
        expect(Review.recent.last).to eq(older_review)
      end
    end
  end
end
