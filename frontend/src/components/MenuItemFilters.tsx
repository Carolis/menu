import React from "react"

export interface FilterOptions {
  name: string
  minPrice: string
  maxPrice: string
}

interface MenuItemFiltersProps {
  filters: FilterOptions
  onFiltersChange: (filters: FilterOptions) => void
  onClearFilters: () => void
}

const MenuItemFilters: React.FC<MenuItemFiltersProps> = ({
  filters,
  onFiltersChange,
  onClearFilters,
}) => {
  const handleInputChange = (field: keyof FilterOptions, value: string) => {
    onFiltersChange({
      ...filters,
      [field]: value,
    })
  }

  const hasActiveFilters = filters.name || filters.minPrice || filters.maxPrice

  return (
    <div className="bg-white border border-gray-200 rounded-lg p-4 mb-6">
      <div className="flex flex-wrap gap-4 items-end">
        <div className="flex-1 min-w-48">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Search items
          </label>
          <input
            type="text"
            value={filters.name}
            onChange={(e) => handleInputChange("name", e.target.value)}
            placeholder="Search menu items..."
            className="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="w-32">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Min Price ($)
          </label>
          <input
            type="number"
            value={filters.minPrice}
            onChange={(e) => handleInputChange("minPrice", e.target.value)}
            placeholder="0.00"
            min="0"
            step="0.01"
            className="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        <div className="w-32">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Max Price ($)
          </label>
          <input
            type="number"
            value={filters.maxPrice}
            onChange={(e) => handleInputChange("maxPrice", e.target.value)}
            placeholder="100.00"
            min="0"
            step="0.01"
            className="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        {hasActiveFilters && (
          <button
            onClick={onClearFilters}
            className="px-4 py-2 text-sm text-gray-600 hover:text-gray-800 border border-gray-300 rounded-md hover:bg-gray-50"
          >
            Clear Filters
          </button>
        )}
      </div>
    </div>
  )
}

export default MenuItemFilters