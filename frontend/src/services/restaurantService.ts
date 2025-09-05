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

export interface Restaurant {
  id: number
  name: string
  created_at: string
  updated_at: string
  menus: Menu[]
}

export interface SearchParams {
  name?: string
  restaurantId?: number
  menuId?: number
  minPrice?: number
  maxPrice?: number
}

export const restaurantService = {
  async getAllRestaurants(searchParams?: { name?: string }): Promise<Restaurant[]> {
    const params = new URLSearchParams()
    if (searchParams?.name) {
      params.append("name", searchParams.name)
    }
    const queryString = params.toString()
    const url = queryString ? `/restaurants?${queryString}` : "/restaurants"
    const response = await api.get<Restaurant[]>(url)
    return response.data
  },

  async getRestaurantById(id: number): Promise<Restaurant> {
    const response = await api.get<Restaurant>(`/restaurants/${id}`)
    return response.data
  },

  async getAllMenuItems(searchParams?: SearchParams): Promise<MenuItem[]> {
    const params = new URLSearchParams()
    if (searchParams?.name) params.append("name", searchParams.name)
    if (searchParams?.restaurantId) params.append("restaurant_id", searchParams.restaurantId.toString())
    if (searchParams?.menuId) params.append("menu_id", searchParams.menuId.toString())
    if (searchParams?.minPrice) params.append("min_price", searchParams.minPrice.toString())
    if (searchParams?.maxPrice) params.append("max_price", searchParams.maxPrice.toString())
    
    const queryString = params.toString()
    const url = queryString ? `/menu_items?${queryString}` : "/menu_items"
    const response = await api.get<MenuItem[]>(url)
    return response.data
  },

  async getMenusByRestaurant(restaurantId: number, searchParams?: { name?: string }): Promise<Menu[]> {
    const params = new URLSearchParams()
    params.append("restaurant_id", restaurantId.toString())
    if (searchParams?.name) params.append("name", searchParams.name)
    
    const queryString = params.toString()
    const response = await api.get<Menu[]>(`/menus?${queryString}`)
    return response.data
  },
}
