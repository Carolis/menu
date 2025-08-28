import { render, screen, fireEvent, waitFor } from "@testing-library/react"
import { vi } from "vitest"
import LoginModal from "../LoginModal"

const mockLogin = vi.fn()
const mockOnClose = vi.fn()
const mockOnSuccess = vi.fn()

vi.mock("../../contexts/AuthContext", () => ({
  useAuth: () => ({
    login: mockLogin,
    isAuthenticated: false,
    logout: vi.fn(),
    credentials: null,
  }),
}))

describe("LoginModal", () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it("renders login form", () => {
    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    expect(screen.getByText("Admin Login")).toBeInTheDocument()
    expect(screen.getByLabelText("Username")).toBeInTheDocument()
    expect(screen.getByLabelText("Password")).toBeInTheDocument()
    expect(screen.getByRole("button", { name: "Login" })).toBeInTheDocument()
  })

  it("shows default credentials info", () => {
    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    expect(screen.getByText("Default credentials:")).toBeInTheDocument()
    expect(screen.getByText(/Username: admin/)).toBeInTheDocument()
    expect(screen.getByText(/Password: password/)).toBeInTheDocument()
  })

  it("calls onClose when cancel button is clicked", () => {
    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    fireEvent.click(screen.getByText("Cancel"))
    expect(mockOnClose).toHaveBeenCalled()
  })

  it("calls onClose when X button is clicked", () => {
    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    fireEvent.click(screen.getByText("×"))
    expect(mockOnClose).toHaveBeenCalled()
  })

  it("handles successful login", async () => {
    mockLogin.mockResolvedValue(true)

    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    fireEvent.change(screen.getByLabelText("Username"), {
      target: { value: "admin" },
    })
    fireEvent.change(screen.getByLabelText("Password"), {
      target: { value: "password" },
    })
    fireEvent.click(screen.getByRole("button", { name: "Login" }))

    await waitFor(() => {
      expect(mockLogin).toHaveBeenCalledWith("admin", "password")
      expect(mockOnSuccess).toHaveBeenCalled()
    })
  })

  it("handles login failure", async () => {
    mockLogin.mockResolvedValue(false)

    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    fireEvent.change(screen.getByLabelText("Username"), {
      target: { value: "wrong" },
    })
    fireEvent.change(screen.getByLabelText("Password"), {
      target: { value: "wrong" },
    })
    fireEvent.click(screen.getByRole("button", { name: "Login" }))

    await waitFor(() => {
      expect(
        screen.getByText("Invalid username or password")
      ).toBeInTheDocument()
      expect(mockOnSuccess).not.toHaveBeenCalled()
    })
  })

  it("shows loading state during login", async () => {
    mockLogin.mockImplementation(
      () => new Promise((resolve) => setTimeout(() => resolve(true), 100))
    )

    render(<LoginModal onClose={mockOnClose} onSuccess={mockOnSuccess} />)

    fireEvent.change(screen.getByLabelText("Username"), {
      target: { value: "admin" },
    })
    fireEvent.change(screen.getByLabelText("Password"), {
      target: { value: "password" },
    })
    fireEvent.click(screen.getByRole("button", { name: "Login" }))

    expect(screen.getByText("Logging in...")).toBeInTheDocument()
    expect(screen.getByRole("button", { name: "Logging in..." })).toBeDisabled()
  })
})
