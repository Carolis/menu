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

  const renderStars = (rating: number) => {
    if (rating === 0) return <span className="text-gray-400">No ratings </span>
    
    return (
      <div className="flex items-center">
        {Array.from({ length: 5 }, (_, i) => (
          <span key={i} className={i < Math.floor(rating) ? "text-yellow-400" : "text-gray-400"}>
            {i < Math.floor(rating) ? "★" : "☆"}
          </span>
        ))}
        <span className="ml-1 text-white">({rating})</span>
      </div>
    )
  }

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
        {restaurant.average_rating !== undefined && (
          <div className="flex items-center mt-2">
            <span className="w-2 h-2 bg-yellow-400 rounded-full mr-2"></span>
            <div className="flex items-center">
              {renderStars(restaurant.average_rating)}
              {restaurant.total_reviews && restaurant.total_reviews > 0 && (
                <span className="ml-2 text-gray-300">({restaurant.total_reviews} reviews)</span>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

export default RestaurantCard
