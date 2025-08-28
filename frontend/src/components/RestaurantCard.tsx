import React from "react"
import type { Restaurant } from "../services/restaurantService"

interface RestaurantCardProps {
  restaurant: Restaurant
  onClick: (restaurant: Restaurant) => void
}

const RestaurantCard: React.FC<RestaurantCardProps> = ({
  restaurant,
  onClick,
}) => {
  const totalItems = restaurant.menus.reduce(
    (sum, menu) => sum + menu.menu_items.length,
    0
  )

  return (
    <div
      style={{ backgroundColor: "rgb(66, 6, 24)" }}
      className="border border-gray-200 rounded-lg p-6 cursor-pointer hover:shadow-lg transition-all duration-200 hover:border-gray-300 hover:-translate-y-1"
      onClick={() => onClick(restaurant)}
      data-testid={`restaurant-card-${restaurant.id}`}
    >
      <h3 className="text-xl font-bold text-white mb-3">
        {restaurant.name}
      </h3>
      <div className="text-sm text-white space-y-1">
        <p className="flex items-center">
          <span className="w-2 h-2 bg-emerald-500 rounded-full mr-2"></span>
          {restaurant.menus.length} menus available
        </p>
        <p className="flex items-center">
          <span className="w-2 h-2 rounded-full mr-2" style={{ backgroundColor: "rgb(81, 226, 239)" }}></span>
          {totalItems} menu item options
        </p>
      </div>
    </div>
  )
}

export default RestaurantCard
