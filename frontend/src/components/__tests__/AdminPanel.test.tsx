import { render, screen, fireEvent, waitFor } from "@testing-library/react"
import { vi } from "vitest"
import AdminPanel from "../AdminPanel"

const mockCredentials = { username: "admin", password: "password" }

vi.mock("../../contexts/AuthContext", () => ({
  useAuth: () => ({
    credentials: mockCredentials,
    isAuthenticated: true,
    login: vi.fn(),
    logout: vi.fn(),
  }),
}))

global.fetch = vi.fn()

describe("AdminPanel", () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(fetch).mockClear()
  })

  it("renders admin panel title and sections", () => {
    render(<AdminPanel />)

    expect(screen.getByText("Admin Panel - JSON Import")).toBeInTheDocument()
    expect(screen.getByText("Import via JSON Text")).toBeInTheDocument()
    expect(screen.getByText("Import via File Upload")).toBeInTheDocument()
  })

  it("shows JSON format example", () => {
    render(<AdminPanel />)

    expect(screen.getByText("JSON Format Example:")).toBeInTheDocument()
    expect(screen.getByText(/"name": "Example Restaurant"/)).toBeInTheDocument()
  })

  it("enables import button when JSON is entered", () => {
    render(<AdminPanel />)

    const textarea = screen.getByPlaceholderText(/Paste your JSON here/)
    const importButton = screen.getByText("Import JSON")

    expect(importButton).toBeDisabled()

    fireEvent.change(textarea, { target: { value: '{"restaurants": []}' } })
    expect(importButton).not.toBeDisabled()
  })

  it("handles successful JSON import", async () => {
    const mockResponse = {
      success: true,
      summary: {
        restaurants_created: 1,
        menus_created: 1,
        menu_items_created: 2,
      },
      logs: [{ type: "info", message: "Import successful" }],
    }

    vi.mocked(fetch).mockResolvedValueOnce({
      ok: true,
      json: () => Promise.resolve(mockResponse),
    } as Response)

    render(<AdminPanel />)

    const textarea = screen.getByPlaceholderText(/Paste your JSON here/)
    const importButton = screen.getByText("Import JSON")

    fireEvent.change(textarea, {
      target: { value: '{"restaurants": [{"name": "Test"}]}' },
    })
    fireEvent.click(importButton)

    await waitFor(() => {
      expect(screen.getByText("Import Successful")).toBeInTheDocument()
      expect(screen.getByText("Restaurants created: 1")).toBeInTheDocument()
      expect(screen.getByText("Menus created: 1")).toBeInTheDocument()
    })

    expect(fetch).toHaveBeenCalledWith(
      expect.stringContaining("/api/v1/import/restaurants"),
      expect.objectContaining({
        method: "POST",
        headers: expect.objectContaining({
          Authorization: "Basic YWRtaW46cGFzc3dvcmQ=",
          "Content-Type": "application/json",
        }),
      })
    )
  })

  it("handles import errors", async () => {
    const mockResponse = {
      success: false,
      error: "Invalid JSON format",
    }

    vi.mocked(fetch).mockResolvedValueOnce({
      ok: false,
      json: () => Promise.resolve(mockResponse),
    } as Response)

    render(<AdminPanel />)

    const textarea = screen.getByPlaceholderText(/Paste your JSON here/)
    const importButton = screen.getByText("Import JSON")

    fireEvent.change(textarea, { target: { value: "invalid json" } })
    fireEvent.click(importButton)

    await waitFor(() => {
      expect(screen.getByText("Import Failed")).toBeInTheDocument()
      expect(screen.getByText(/Unexpected token/)).toBeInTheDocument()
    })
  })

  it("shows loading state during import", async () => {
    vi.mocked(fetch).mockImplementation(
      () =>
        new Promise((resolve) =>
          setTimeout(
            () =>
              resolve({
                ok: true,
                json: () => Promise.resolve({ success: true, logs: [] }),
              } as Response),
            100
          )
        )
    )

    render(<AdminPanel />)

    const textarea = screen.getByPlaceholderText(/Paste your JSON here/)
    const importButton = screen.getByText("Import JSON")

    fireEvent.change(textarea, { target: { value: '{"restaurants": []}' } })
    fireEvent.click(importButton)

    expect(screen.getByText("Importing...")).toBeInTheDocument()
    expect(screen.getByText("Importing...")).toBeDisabled()
  })

  it("handles file selection", () => {
    const { container } = render(<AdminPanel />)

    const file = new File(['{"restaurants": []}'], "test.json", {
      type: "application/json",
    })

    const fileInputElement = container.querySelector('input[type="file"]')
    expect(fileInputElement).toBeInTheDocument()

    fireEvent.change(fileInputElement!, { target: { files: [file] } })

    const uploadButton = screen.getByText("Upload File")
    expect(uploadButton).not.toBeDisabled()
  })
})
