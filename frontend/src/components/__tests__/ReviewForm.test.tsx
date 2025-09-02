import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { describe, it, expect, vi } from 'vitest'
import ReviewForm from '../ReviewForm'

describe('ReviewForm', () => {
  const mockOnSubmit = vi.fn()
  const mockOnCancel = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('renders all form fields', () => {
    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
      />
    )

    expect(screen.getByLabelText(/name/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/rating/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/comment/i)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /submit review/i })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /cancel/i })).toBeInTheDocument()
    expect(screen.getByText('★★★★★ (5 stars)')).toBeInTheDocument()
  })

  it('submits form with correct data', async () => {
    mockOnSubmit.mockResolvedValueOnce(undefined)

    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
      />
    )

    fireEvent.change(screen.getByLabelText(/name/i), {
      target: { value: 'John Doe' }
    })
    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'john@example.com' }
    })
    fireEvent.change(screen.getByLabelText(/rating/i), {
      target: { value: '4' }
    })
    fireEvent.change(screen.getByLabelText(/comment/i), {
      target: { value: 'Great food!' }
    })

    fireEvent.click(screen.getByRole('button', { name: /submit review/i }))

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        reviewer_name: 'John Doe',
        reviewer_email: 'john@example.com',
        rating: 4,
        comment: 'Great food!'
      })
    })
  })

  it('calls onCancel when cancel button is clicked', () => {
    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
      />
    )

    fireEvent.click(screen.getByRole('button', { name: /cancel/i }))
    expect(mockOnCancel).toHaveBeenCalled()
  })

  it('shows submit button as disabled when submitting', () => {
    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
        isSubmitting={true}
      />
    )

    expect(screen.getByRole('button', { name: /submitting/i })).toBeDisabled()
  })

  it('updates character count for comment field', () => {
    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
      />
    )

    const commentField = screen.getByLabelText(/comment/i)
    fireEvent.change(commentField, {
      target: { value: 'Test comment' }
    })

    expect(screen.getByText('12/500 characters')).toBeInTheDocument()
  })

  it('shows error messages when submission fails', async () => {
    const errorResponse = {
      response: {
        data: {
          errors: ['Name is required', 'Rating must be between 1 and 5']
        }
      }
    }
    mockOnSubmit.mockRejectedValueOnce(errorResponse)

    render(
      <ReviewForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
      />
    )

    fireEvent.click(screen.getByRole('button', { name: /submit review/i }))

    await waitFor(() => {
      expect(screen.getByText('Name is required')).toBeInTheDocument()
      expect(screen.getByText('Rating must be between 1 and 5')).toBeInTheDocument()
    })
  })
})