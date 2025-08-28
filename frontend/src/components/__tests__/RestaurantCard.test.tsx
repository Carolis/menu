import { render, screen, fireEvent } from "@testing-library/react"
import { describe, it, expect, vi } from "vitest"
import RestaurantCard from "../RestaurantCard"
import type { Restaurant } from "../../services/restaurantService"

const mockRestaurant: Restaurant = {
  id: 1,
  name: "Test Restaurant",
  created_at: "2025-01-01T00:00:00.000Z",
  updated_at: "2025-01-01T00:00:00.000Z",
  menus: [
    {
      id: 1,
      name: "lunch",
      restaurant_id: 1,
      created_at: "2025-01-01T00:00:00.000Z",
      updated_at: "2025-01-01T00:00:00.000Z",
      menu_items: [
        {
          id: 1,
          name: "Test Item",
          price: "10.00",
          created_at: "2025-01-01T00:00:00.000Z",
          updated_at: "2025-01-01T00:00:00.000Z",
        },
      ],
    },
  ],
}

describe("RestaurantCard", () => {
  it("renders restaurant information correctly", () => {
    const mockOnClick = vi.fn()

    render(<RestaurantCard restaurant={mockRestaurant} onClick={mockOnClick} />)

    expect(screen.getByText("Test Restaurant")).toBeInTheDocument()
    expect(screen.getByText("1 menus available")).toBeInTheDocument()
    expect(screen.getByText("1 menu item options")).toBeInTheDocument()
  })

  it("calls onClick when card is clicked", () => {
    const mockOnClick = vi.fn()

    render(<RestaurantCard restaurant={mockRestaurant} onClick={mockOnClick} />)

    fireEvent.click(screen.getByTestId("restaurant-card-1"))
    expect(mockOnClick).toHaveBeenCalledWith(mockRestaurant)
  })
})
