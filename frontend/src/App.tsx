import { useState } from "react"
import { AuthProvider } from "./contexts/AuthContext"
import Header from "./components/Header"
import RestaurantList from "./components/RestaurantList"
import RestaurantMenu from "./components/RestaurantMenu"
import AdminPanel from "./components/AdminPanel"
import { type Restaurant } from "./services/restaurantService"

function App() {
  const [selectedRestaurant, setSelectedRestaurant] =
    useState<Restaurant | null>(null)
  const [showAdmin, setShowAdmin] = useState(false)

  const handleRestaurantSelect = (restaurant: Restaurant) => {
    setSelectedRestaurant(restaurant)
    setShowAdmin(false)
  }

  const handleBackToList = () => {
    setSelectedRestaurant(null)
  }

  const handleAdminToggle = () => {
    setShowAdmin(!showAdmin)
    setSelectedRestaurant(null)
  }

  return (
    <AuthProvider>
      <div className="min-h-screen bg-gray-50">
        <Header onAdminToggle={handleAdminToggle} showAdmin={showAdmin} />

        <div className="container mx-auto px-4 py-8">
          {showAdmin ? (
            <AdminPanel />
          ) : selectedRestaurant ? (
            <RestaurantMenu
              restaurant={selectedRestaurant}
              onBack={handleBackToList}
            />
          ) : (
            <RestaurantList onRestaurantSelect={handleRestaurantSelect} />
          )}
        </div>
      </div>
    </AuthProvider>
  )
}

export default App
