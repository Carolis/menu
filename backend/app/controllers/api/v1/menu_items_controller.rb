class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [ :show, :update, :destroy ]

  def index
    @menu_items = MenuItem.includes(:menu).all
    render json: @menu_items, include: :menu, status: :ok
  end

  def show
    render json: @menu_item, include: :menu, status: :ok
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      render json: @menu_item, include: :menu, status: :created, location: api_v1_menu_item_url(@menu_item)
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item, include: :menu, status: :ok
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
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
    params.require(:menu_item).permit(:name, :price, :menu_id)
  end
end
