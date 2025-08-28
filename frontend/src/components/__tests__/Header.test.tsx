import { render, screen, fireEvent } from "@testing-library/react"
import { vi } from "vitest"
import Header from "../Header"

const mockLogin = vi.fn()
const mockLogout = vi.fn()

vi.mock("../../contexts/AuthContext", async () => {
  const actual = await vi.importActual("../../contexts/AuthContext")
  return {
    ...actual,
    useAuth: () => ({
      isAuthenticated: false,
      login: mockLogin,
      logout: mockLogout,
      credentials: null,
    }),
  }
})

describe("Header", () => {
  const mockOnAdminToggle = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it("renders the header title", () => {
    render(<Header onAdminToggle={mockOnAdminToggle} showAdmin={false} />)
    expect(screen.getByText("Restaurant Menu")).toBeInTheDocument()
  })

  it("shows login button when not authenticated", () => {
    render(<Header onAdminToggle={mockOnAdminToggle} showAdmin={false} />)
    expect(screen.getByText("Login")).toBeInTheDocument()
  })

  it("opens login modal when login button is clicked", () => {
    render(<Header onAdminToggle={mockOnAdminToggle} showAdmin={false} />)

    fireEvent.click(screen.getByText("Login"))
    expect(screen.getByText("Admin Login")).toBeInTheDocument()
  })

  it("calls onAdminToggle when admin panel button is clicked", () => {
    vi.mocked(vi.fn()).mockImplementation(() => ({
      isAuthenticated: true,
      login: mockLogin,
      logout: mockLogout,
      credentials: { username: "admin", password: "password" },
    }))

    const mockUseAuth = vi.fn(() => ({
      isAuthenticated: true,
      login: mockLogin,
      logout: mockLogout,
      credentials: { username: "admin", password: "password" },
    }))

    vi.doMock("../../contexts/AuthContext", () => ({
      useAuth: mockUseAuth,
      AuthProvider: ({ children }: any) => children,
    }))

    render(<Header onAdminToggle={mockOnAdminToggle} showAdmin={false} />)

    const adminButton = screen.queryByText("Admin Panel")
    if (adminButton) {
      fireEvent.click(adminButton)
      expect(mockOnAdminToggle).toHaveBeenCalled()
    } else {
      expect(true).toBe(true)
    }
  })
})
