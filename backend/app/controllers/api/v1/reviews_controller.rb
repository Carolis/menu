class Api::V1::ReviewsController < ApplicationController
  before_action :set_restaurant
  before_action :set_review, only: [:show, :update, :destroy]

  def index
    @reviews = @restaurant.reviews.includes(:restaurant).recent
    render json: @reviews, status: :ok
  end

  def show
    render json: @review, status: :ok
  end

  def create
    @review = @restaurant.reviews.build(review_params)

    if @review.save
      render json: @review, status: :created
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @review.update(review_params)
      render json: @review, status: :ok
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @review.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Restaurant not found" }, status: :not_found
  end

  def set_review
    @review = @restaurant.reviews.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Review not found" }, status: :not_found
  end

  def review_params
    params.require(:review).permit(:rating, :reviewer_name, :reviewer_email, :comment)
  end
end