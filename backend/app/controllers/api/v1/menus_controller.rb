class Api::V1::MenusController < ApplicationController
  before_action :set_menu, only: [ :show, :update, :destroy ]

  def index
    @menus = Menu.includes(:menu_items)
                 .search_by_name(params[:name])
                 .by_restaurant(params[:restaurant_id])
    render json: @menus, include: :menu_items, status: :ok
  end

  def show
    render json: @menu, include: :menu_items, status: :ok
  end

  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      render json: @menu, status: :created, location: api_v1_menu_url(@menu)
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @menu.update(menu_params)
      render json: @menu, include: :menu_items, status: :ok
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @menu.destroy
    head :no_content
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Menu not found" }, status: :not_found
  end

  def menu_params
    params.require(:menu).permit(:name)
  end
end
