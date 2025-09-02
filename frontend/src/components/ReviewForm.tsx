import React, { useState } from "react"
import type { Review } from "../services/restaurantService"

interface ReviewFormProps {
  onSubmit: (reviewData: Omit<Review, 'id' | 'restaurant_id' | 'created_at' | 'updated_at'>) => Promise<void>
  onCancel: () => void
  isSubmitting?: boolean
}

const ReviewForm: React.FC<ReviewFormProps> = ({ onSubmit, onCancel, isSubmitting = false }) => {
  const [formData, setFormData] = useState({
    reviewer_name: "",
    reviewer_email: "",
    rating: 5,
    comment: "",
  })
  const [errors, setErrors] = useState<string[]>([])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setErrors([])

    try {
      await onSubmit(formData)
      setFormData({ reviewer_name: "", reviewer_email: "", rating: 5, comment: "" })
    } catch (error: any) {
      if (error.response?.data?.errors) {
        setErrors(error.response.data.errors)
      } else {
        setErrors(["An error occurred while submitting your review"])
      }
    }
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: name === "rating" ? parseInt(value) : value
    }))
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <h3 className="text-lg font-semibold text-white mb-4">Write a Review</h3>
      
      {errors.length > 0 && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
          <ul className="list-disc list-inside">
            {errors.map((error, index) => (
              <li key={index}>{error}</li>
            ))}
          </ul>
        </div>
      )}

      <div>
        <label htmlFor="reviewer_name" className="block text-sm font-medium text-white mb-1">
          Name *
        </label>
        <input
          type="text"
          id="reviewer_name"
          name="reviewer_name"
          value={formData.reviewer_name}
          onChange={handleChange}
          required
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Your name"
        />
      </div>

      <div>
        <label htmlFor="reviewer_email" className="block text-sm font-medium text-white mb-1">
          Email (optional)
        </label>
        <input
          type="email"
          id="reviewer_email"
          name="reviewer_email"
          value={formData.reviewer_email}
          onChange={handleChange}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="your.email@example.com"
        />
      </div>

      <div>
        <label htmlFor="rating" className="block text-sm font-medium text-white mb-1">
          Rating *
        </label>
        <select
          id="rating"
          name="rating"
          value={formData.rating}
          onChange={handleChange}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value={5}>⭐⭐⭐⭐⭐ (5 stars)</option>
          <option value={4}>⭐⭐⭐⭐ (4 stars)</option>
          <option value={3}>⭐⭐⭐ (3 stars)</option>
          <option value={2}>⭐⭐ (2 stars)</option>
          <option value={1}>⭐ (1 star)</option>
        </select>
      </div>

      <div>
        <label htmlFor="comment" className="block text-sm font-medium text-white mb-1">
          Comment (optional)
        </label>
        <textarea
          id="comment"
          name="comment"
          value={formData.comment}
          onChange={handleChange}
          rows={4}
          className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          placeholder="Share your experience..."
          maxLength={500}
        />
        <p className="text-xs text-gray-300 mt-1">
          {formData.comment.length}/500 characters
        </p>
      </div>

      <div className="flex gap-3 pt-2">
        <button
          type="submit"
          disabled={isSubmitting}
          className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
        >
          {isSubmitting ? "Submitting..." : "Submit Review"}
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500"
        >
          Cancel
        </button>
      </div>
    </form>
  )
}

export default ReviewForm