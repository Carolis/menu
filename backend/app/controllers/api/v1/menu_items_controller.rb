class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [ :show, :update, :destroy ]

  def index
    @menu_items = MenuItem.includes(:menus)
                          .search_by_name(params[:name])
                          .price_range(params[:min_price], params[:max_price])
                          .by_restaurant(params[:restaurant_id])
                          .by_menu(params[:menu_id])
    render json: @menu_items, include: :menus, status: :ok
  end

  def show
    render json: @menu_item, include: :menus, status: :ok
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      render json: @menu_item, include: :menus, status: :created, location: api_v1_menu_item_url(@menu_item)
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item, include: :menus, status: :ok
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Menu item not found" }, status: :not_found
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, menu_ids: [])
  end
end
