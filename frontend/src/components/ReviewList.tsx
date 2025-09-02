import React from "react"
import type { Review } from "../services/restaurantService"

interface ReviewListProps {
  reviews: Review[]
  isLoading?: boolean
}

const ReviewList: React.FC<ReviewListProps> = ({ reviews, isLoading = false }) => {
  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }

  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }, (_, i) => (
      <span key={i} className={i < rating ? "text-yellow-400" : "text-gray-400"}>
        {i < rating ? "★" : "☆"}
      </span>
    ))
  }

  if (isLoading) {
    return (
      <div className="space-y-4">
        <h3 className="text-lg font-semibold text-white">Reviews</h3>
        <div className="animate-pulse">
          <div className="bg-gray-700 h-20 rounded-md mb-4"></div>
          <div className="bg-gray-700 h-20 rounded-md mb-4"></div>
          <div className="bg-gray-700 h-20 rounded-md"></div>
        </div>
      </div>
    )
  }

  if (reviews.length === 0) {
    return (
      <div className="space-y-4">
        <h3 className="text-lg font-semibold text-white">Reviews (0)</h3>
        <div className="text-gray-300 text-center py-8">
          No reviews yet. Be the first to review this restaurant!
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold text-white">Reviews ({reviews.length})</h3>
      <div className="space-y-4">
        {reviews.map((review) => (
          <div
            key={review.id}
            className="bg-gray-800 border border-gray-600 rounded-lg p-4"
          >
            <div className="flex items-center justify-between mb-2">
              <div className="flex items-center space-x-2">
                <span className="font-medium text-white">{review.reviewer_name}</span>
                <div className="flex">{renderStars(review.rating)}</div>
              </div>
              <span className="text-sm text-gray-400">
                {formatDate(review.created_at)}
              </span>
            </div>
            {review.comment && (
              <p className="text-gray-300 mt-2">{review.comment}</p>
            )}
          </div>
        ))}
      </div>
    </div>
  )
}

export default ReviewList