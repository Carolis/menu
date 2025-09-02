import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import ReviewList from '../ReviewList'
import type { Review } from '../../services/restaurantService'

describe('ReviewList', () => {
  const mockReviews: Review[] = [
    {
      id: 1,
      restaurant_id: 1,
      reviewer_name: 'John Doe',
      reviewer_email: 'john@example.com',
      rating: 5,
      comment: 'Excellent food and service!',
      created_at: '2024-01-15T10:00:00Z',
      updated_at: '2024-01-15T10:00:00Z'
    },
    {
      id: 2,
      restaurant_id: 1,
      reviewer_name: 'Jane Smith',
      reviewer_email: 'jane@example.com',
      rating: 4,
      comment: 'Good experience overall.',
      created_at: '2024-01-14T15:30:00Z',
      updated_at: '2024-01-14T15:30:00Z'
    }
  ]

  it('renders reviews correctly', () => {
    render(<ReviewList reviews={mockReviews} />)

    expect(screen.getByText('Reviews (2)')).toBeInTheDocument()
    expect(screen.getByText('John Doe')).toBeInTheDocument()
    expect(screen.getByText('Jane Smith')).toBeInTheDocument()
    expect(screen.getByText('Excellent food and service!')).toBeInTheDocument()
    expect(screen.getByText('Good experience overall.')).toBeInTheDocument()
  })

  it('displays star ratings correctly', () => {
    render(<ReviewList reviews={mockReviews} />)

    const filledStars = screen.getAllByText('★')
    const emptyStars = screen.getAllByText('☆')
    
    expect(filledStars).toHaveLength(9)
    expect(emptyStars).toHaveLength(1)
  })

  it('formats dates correctly', () => {
    render(<ReviewList reviews={mockReviews} />)

    expect(screen.getByText('Jan 15, 2024')).toBeInTheDocument()
    expect(screen.getByText('Jan 14, 2024')).toBeInTheDocument()
  })

  it('shows loading state', () => {
    render(<ReviewList reviews={[]} isLoading={true} />)

    expect(screen.getByText('Reviews')).toBeInTheDocument()
    expect(document.querySelector('.animate-pulse')).toBeInTheDocument()
  })

  it('shows empty state when no reviews', () => {
    render(<ReviewList reviews={[]} isLoading={false} />)

    expect(screen.getByText('Reviews (0)')).toBeInTheDocument()
    expect(screen.getByText('No reviews yet. Be the first to review this restaurant!')).toBeInTheDocument()
  })

  it('handles reviews without comments', () => {
    const reviewsWithoutComment: Review[] = [
      {
        id: 3,
        restaurant_id: 1,
        reviewer_name: 'Bob Wilson',
        reviewer_email: 'bob@example.com',
        rating: 3,
        comment: '',
        created_at: '2024-01-13T12:00:00Z',
        updated_at: '2024-01-13T12:00:00Z'
      }
    ]

    render(<ReviewList reviews={reviewsWithoutComment} />)

    expect(screen.getByText('Bob Wilson')).toBeInTheDocument()
    expect(screen.getAllByText('★')).toHaveLength(3)
    expect(screen.getAllByText('☆')).toHaveLength(2)
  })
})