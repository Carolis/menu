import { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { API_BASE_URL } from '../config/api'

interface AuthContextType {
  isAuthenticated: boolean
  credentials: { username: string; password: string } | null
  login: (username: string, password: string) => Promise<boolean>
  logout: () => void
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}

interface AuthProviderProps {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const [credentials, setCredentials] = useState<{ username: string; password: string } | null>(null)

  const login = async (username: string, password: string): Promise<boolean> => {
    try {
      const response = await fetch(`${API_BASE_URL}/auth/verify`, {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa(`${username}:${password}`)}`,
          'Content-Type': 'application/json',
        },
      })

      if (response.ok) {
        setIsAuthenticated(true)
        setCredentials({ username, password })
        localStorage.setItem('auth_credentials', JSON.stringify({ username, password }))
        return true
      }
      return false
    } catch (error) {
      console.error('Login failed:', error)
      return false
    }
  }

  const logout = () => {
    setIsAuthenticated(false)
    setCredentials(null)
    localStorage.removeItem('auth_credentials')
  }

  useEffect(() => {
    const savedCredentials = localStorage.getItem('auth_credentials')
    if (savedCredentials) {
      try {
        const { username, password } = JSON.parse(savedCredentials)
        login(username, password)
      } catch {
        localStorage.removeItem('auth_credentials')
      }
    }
  }, [])

  return (
    <AuthContext.Provider value={{ isAuthenticated, credentials, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}