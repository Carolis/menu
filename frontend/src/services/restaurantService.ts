import axios from "axios"
import { API_BASE_URL } from "../config/api"

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
})

export interface MenuItem {
  id: number
  name: string
  price: string
  created_at: string
  updated_at: string
}

export interface Menu {
  id: number
  name: string
  restaurant_id: number
  created_at: string
  updated_at: string
  menu_items: MenuItem[]
}

export interface Review {
  id: number
  restaurant_id: number
  reviewer_name: string
  reviewer_email: string
  rating: number
  comment: string
  created_at: string
  updated_at: string
}

export interface Restaurant {
  id: number
  name: string
  created_at: string
  updated_at: string
  menus: Menu[]
  average_rating?: number
  total_reviews?: number
}

export const restaurantService = {
  async getAllRestaurants(): Promise<Restaurant[]> {
    const response = await api.get<Restaurant[]>("/restaurants")
    return response.data
  },

  async getRestaurantById(id: number): Promise<Restaurant> {
    const response = await api.get<Restaurant>(`/restaurants/${id}`)
    return response.data
  },

  async getAllMenuItems(): Promise<MenuItem[]> {
    const response = await api.get<MenuItem[]>("/menu_items")
    return response.data
  },

  async getReviews(restaurantId: number): Promise<Review[]> {
    const response = await api.get<Review[]>(`/restaurants/${restaurantId}/reviews`)
    return response.data
  },

  async createReview(restaurantId: number, reviewData: Omit<Review, 'id' | 'restaurant_id' | 'created_at' | 'updated_at'>): Promise<Review> {
    const response = await api.post<Review>(`/restaurants/${restaurantId}/reviews`, { review: reviewData })
    return response.data
  },
}
