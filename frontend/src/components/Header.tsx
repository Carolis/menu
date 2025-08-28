import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import LoginModal from './LoginModal'

interface HeaderProps {
  onAdminToggle: () => void
  showAdmin: boolean
}

export default function Header({ onAdminToggle, showAdmin }: HeaderProps) {
  const { isAuthenticated, logout } = useAuth()
  const [showLoginModal, setShowLoginModal] = useState(false)

  const handleLoginClick = () => {
    if (isAuthenticated) {
      onAdminToggle()
    } else {
      setShowLoginModal(true)
    }
  }

  const handleLoginSuccess = () => {
    setShowLoginModal(false)
    onAdminToggle()
  }

  return (
    <header className="bg-white shadow-sm border-b">
      <div className="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 className="text-2xl font-bold" style={{ color: "rgb(10, 32, 47)" }}>Restaurant Menu</h1>
        
        <div className="flex items-center space-x-4">
          {isAuthenticated && (
            <button
              onClick={onAdminToggle}
              className="px-4 py-2 rounded-md text-sm font-medium text-white hover:opacity-80"
              style={{ backgroundColor: "rgb(66, 6, 24)" }}
            >
              {showAdmin ? 'View Restaurants' : 'Admin Panel'}
            </button>
          )}
          
          <button
            onClick={isAuthenticated ? logout : handleLoginClick}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              isAuthenticated
                ? 'text-white hover:opacity-80'
                : 'text-white hover:opacity-80'
            }`}
            style={{ 
              backgroundColor: isAuthenticated ? "rgb(200, 50, 50)" : "rgb(81, 226, 239)"
            }}
          >
            {isAuthenticated ? 'Logout' : 'Login'}
          </button>
        </div>
      </div>

      {showLoginModal && (
        <LoginModal
          onClose={() => setShowLoginModal(false)}
          onSuccess={handleLoginSuccess}
        />
      )}
    </header>
  )
}