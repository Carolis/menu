import { render, screen, waitFor } from "@testing-library/react"
import { describe, it, expect, vi, beforeEach } from "vitest"
import RestaurantList from "../RestaurantList"
import { restaurantService } from "../../services/restaurantService"

vi.mock("../../services/restaurantService")
const mockedRestaurantService = vi.mocked(restaurantService)

describe("RestaurantList", () => {
  const mockOnRestaurantSelect = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it("displays loading state initially", () => {
    mockedRestaurantService.getAllRestaurants.mockImplementation(
      () => new Promise(() => {})
    )

    render(<RestaurantList onRestaurantSelect={mockOnRestaurantSelect} />)

    expect(screen.getByTestId("loading")).toBeInTheDocument()
  })

  it("displays restaurants when loaded successfully", async () => {
    const mockRestaurants = [
      {
        id: 1,
        name: "Restaurant 1",
        created_at: "2025-01-01T00:00:00.000Z",
        updated_at: "2025-01-01T00:00:00.000Z",
        menus: [],
      },
    ]

    mockedRestaurantService.getAllRestaurants.mockResolvedValue(mockRestaurants)

    render(<RestaurantList onRestaurantSelect={mockOnRestaurantSelect} />)

    await waitFor(() => {
      expect(screen.getByText("Choose Your Restaurant")).toBeInTheDocument()
      expect(screen.getByText("Restaurant 1")).toBeInTheDocument()
    })
  })

  it("displays error message when API call fails", async () => {
    mockedRestaurantService.getAllRestaurants.mockRejectedValue(
      new Error("API Error")
    )

    render(<RestaurantList onRestaurantSelect={mockOnRestaurantSelect} />)

    await waitFor(() => {
      expect(screen.getByTestId("error")).toBeInTheDocument()
      expect(screen.getByText(/API Error/)).toBeInTheDocument()
    })
  })

  it("displays no restaurants message when list is empty", async () => {
    mockedRestaurantService.getAllRestaurants.mockResolvedValue([])

    render(<RestaurantList onRestaurantSelect={mockOnRestaurantSelect} />)

    await waitFor(() => {
      expect(screen.getByTestId("no-restaurants")).toBeInTheDocument()
    })
  })
})
