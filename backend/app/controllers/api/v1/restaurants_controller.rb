class Api::V1::RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [ :show, :update, :destroy ]

  def index
    @restaurants = Restaurant.includes(menus: :menu_items).all
    render json: @restaurants, include: { menus: { include: :menu_items } }, status: :ok
  end

  def show
    render json: @restaurant, include: { menus: { include: :menu_items } }, status: :ok
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: @restaurant, status: :created, location: api_v1_restaurant_url(@restaurant)
    else
      render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant, include: { menus: { include: :menu_items } }, status: :ok
    else
      render json: { errors: @restaurant.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Restaurant not found" }, status: :not_found
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
