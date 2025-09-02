import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { restaurantService } from '../restaurantService'
import type { Review } from '../restaurantService'

vi.mock('axios', () => ({
  default: {
    create: vi.fn()
  }
}))

const mockedAxios = vi.mocked(axios)

describe('restaurantService', () => {
  const mockApi = {
    get: vi.fn(),
    post: vi.fn()
  }

  beforeEach(() => {
    vi.clearAllMocks()
    mockedAxios.create.mockReturnValue(mockApi as any)
  })

  describe('getReviews', () => {
    it('fetches reviews for a restaurant', async () => {
      const mockReviews: Review[] = [
        {
          id: 1,
          restaurant_id: 1,
          reviewer_name: 'John Doe',
          reviewer_email: 'john@example.com',
          rating: 5,
          comment: 'Great food!',
          created_at: '2024-01-15T10:00:00Z',
          updated_at: '2024-01-15T10:00:00Z'
        }
      ]

      mockApi.get.mockResolvedValueOnce({ data: mockReviews })

      const reviews = await restaurantService.getReviews(1)
      expect(reviews).toEqual(mockReviews)
      expect(mockApi.get).toHaveBeenCalledWith('/restaurants/1/reviews')
    })
  })

  describe('createReview', () => {
    it('creates a new review', async () => {
      const reviewData = {
        reviewer_name: 'Jane Smith',
        reviewer_email: 'jane@example.com',
        rating: 4,
        comment: 'Good experience'
      }

      const mockCreatedReview: Review = {
        id: 2,
        restaurant_id: 1,
        ...reviewData,
        created_at: '2024-01-15T10:00:00Z',
        updated_at: '2024-01-15T10:00:00Z'
      }

      mockApi.post.mockResolvedValueOnce({ data: mockCreatedReview })

      const result = await restaurantService.createReview(1, reviewData)
      expect(result).toEqual(mockCreatedReview)
    })

    it('sends review data in correct format', async () => {
      const reviewData = {
        reviewer_name: 'Jane Smith',
        reviewer_email: 'jane@example.com',
        rating: 4,
        comment: 'Good experience'
      }

      mockApi.post.mockResolvedValueOnce({ data: {} })

      await restaurantService.createReview(1, reviewData)
      
      expect(mockApi.post).toHaveBeenCalledWith('/restaurants/1/reviews', {
        review: reviewData
      })
    })
  })
})