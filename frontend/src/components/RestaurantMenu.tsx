import React from "react"
import { type Restaurant } from "../services/restaurantService"

interface RestaurantMenuProps {
  restaurant: Restaurant
  onBack: () => void
}

const RestaurantMenu: React.FC<RestaurantMenuProps> = ({
  restaurant,
  onBack,
}) => {
  return (
    <div className="max-w-4xl mx-auto">
      <div className="mb-8">
        <button
          onClick={onBack}
          className="cursor-pointer inline-flex items-center text-rose-400 hover:text-rose-600 font-medium mb-6 transition-colors duration-200"
          data-testid="back-button"
        >
          <svg
            className="w-5 h-5 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M15 19l-7-7 7-7"
            />
          </svg>
          Back to restaurants
        </button>

        <div className="rounded-lg shadow-sm border border-gray-200 p-6 mb-8" style={{ backgroundColor: 'rgb(66, 6, 24)' }}>
          <h1 className="text-4xl font-bold text-white mb-2">
            {restaurant.name}
          </h1>
        </div>
      </div>

      <div className="space-y-8">
        {restaurant.menus.map((menu) => (
          <div
            key={menu.id}
            className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden"
          >
            <div className="bg-gray-50 px-6 py-4 border-b border-gray-200">
              <h2 className="text-2xl font-bold text-gray-800 capitalize">
                {menu.name} Menu
              </h2>
            </div>

            <div className="p-6">
              {menu.menu_items.length === 0 ? (
                <div className="text-center py-8">
                  <p className="text-gray-500">
                    No items available in this menu
                  </p>
                </div>
              ) : (
                <div className="space-y-4">
                  {menu.menu_items.map((item) => (
                    <div
                      key={item.id}
                      className="flex justify-between items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors duration-150"
                      data-testid={`menu-item-${item.id}`}
                    >
                      <div className="flex-1">
                        <h3 className="font-semibold text-gray-800 text-lg">
                          {item.name}
                        </h3>
                      </div>
                      <div className="flex items-center ml-4">
                        <span className="text-2xl font-bold" style={{ color: "rgb(74, 201, 109)" }}>
                          ${parseFloat(item.price).toFixed(2)}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default RestaurantMenu
