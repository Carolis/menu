import React, { useEffect, useState } from "react"
import {
  type Restaurant,
  restaurantService,
} from "../services/restaurantService"
import RestaurantCard from "./RestaurantCard"

interface RestaurantListProps {
  onRestaurantSelect: (restaurant: Restaurant) => void
}

const RestaurantList: React.FC<RestaurantListProps> = ({
  onRestaurantSelect,
}) => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const fetchRestaurants = async () => {
      try {
        setLoading(true)
        const data = await restaurantService.getAllRestaurants()
        setRestaurants(data)
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "Failed to load restaurants"
        )
      } finally {
        setLoading(false)
      }
    }

    fetchRestaurants()
  }, [])

  if (loading) {
    return (
      <div
        className="flex justify-center items-center h-64"
        data-testid="loading"
      >
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <div className="ml-4 text-lg text-gray-600">Loading restaurants...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div
        className="bg-red-50 border border-red-200 rounded-lg p-6 text-center"
        data-testid="error"
      >
        <div className="text-red-800 font-semibold mb-2">
          Error loading restaurants
        </div>
        <div className="text-red-600">{error}</div>
      </div>
    )
  }

  if (restaurants.length === 0) {
    return (
      <div className="text-center p-12" data-testid="no-restaurants">
        <h3 className="text-xl font-semibold text-gray-700 mb-2">
          No restaurants available in your region
        </h3>
        <p className="text-gray-500">Check back later!</p>
      </div>
    )
  }

  return (
    <div className="max-w-7xl mx-auto">
      <div className="mb-8">
        <h1
          className="text-4xl font-bold text-gray-800 mb-2"
          style={{ color: "rgb(10, 32, 47)" }}
        >
          Choose Your Restaurant
        </h1>
        <p className="text-gray-600">
          Discover POPular food all around the world!
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {restaurants.map((restaurant) => (
          <RestaurantCard
            key={restaurant.id}
            restaurant={restaurant}
            onClick={onRestaurantSelect}
          />
        ))}
      </div>
    </div>
  )
}

export default RestaurantList
