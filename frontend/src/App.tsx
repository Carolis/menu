import { useState } from "react"
import RestaurantList from "./components/RestaurantList"
import RestaurantMenu from "./components/RestaurantMenu"
import { type Restaurant } from "./services/restaurantService"

function App() {
  const [selectedRestaurant, setSelectedRestaurant] =
    useState<Restaurant | null>(null)

  const handleRestaurantSelect = (restaurant: Restaurant) => {
    setSelectedRestaurant(restaurant)
  }

  const handleBackToList = () => {
    setSelectedRestaurant(null)
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        {selectedRestaurant ? (
          <RestaurantMenu
            restaurant={selectedRestaurant}
            onBack={handleBackToList}
          />
        ) : (
          <RestaurantList onRestaurantSelect={handleRestaurantSelect} />
        )}
      </div>
    </div>
  )
}

export default App
