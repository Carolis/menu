import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { API_BASE_URL } from '../config/api'

interface ImportResult {
  success: boolean
  summary?: {
    restaurants_created: number
    menus_created: number
    menu_items_created: number
  }
  logs?: Array<{ type: string; message: string; timestamp?: string }>
  errors?: string[]
  error?: string
}

export default function AdminPanel() {
  const { credentials } = useAuth()
  const [jsonInput, setJsonInput] = useState('')
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<ImportResult | null>(null)

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file && file.type === 'application/json') {
      setSelectedFile(file)
      
      const reader = new FileReader()
      reader.onload = (event) => {
        try {
          const content = event.target?.result as string
          const parsed = JSON.parse(content)
          setJsonInput(JSON.stringify(parsed, null, 2))
        } catch {
          alert('Invalid JSON file')
        }
      }
      reader.readAsText(file)
    } else {
      alert('Please select a JSON file')
    }
  }

  const handleJsonSubmit = async () => {
    if (!jsonInput.trim() || !credentials) return

    setLoading(true)
    setResult(null)

    try {
      const parsedJson = JSON.parse(jsonInput)
      
      const response = await fetch(`${API_BASE_URL}/import/restaurants`, {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa(`${credentials.username}:${credentials.password}`)}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ data: parsedJson })
      })

      const data = await response.json()
      setResult(data)
    } catch (error: any) {
      setResult({
        success: false,
        error: error.message || 'Failed to import JSON data'
      })
    } finally {
      setLoading(false)
    }
  }

  const handleFileSubmit = async () => {
    if (!selectedFile || !credentials) return

    setLoading(true)
    setResult(null)

    const formData = new FormData()
    formData.append('file', selectedFile)

    try {
      const response = await fetch(`${API_BASE_URL}/import/restaurants`, {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa(`${credentials.username}:${credentials.password}`)}`
        },
        body: formData
      })

      const data = await response.json()
      setResult(data)
    } catch (error: any) {
      setResult({
        success: false,
        error: error.message || 'Failed to upload file'
      })
    } finally {
      setLoading(false)
    }
  }

  const renderResult = () => {
    if (!result) return null

    return (
      <div className={`mt-6 p-4 rounded-md ${result.success ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'} border`}>
        <div className="flex items-center mb-2">
          <span className={`text-sm font-medium ${result.success ? 'text-green-800' : 'text-red-800'}`}>
            {result.success ? 'Import Successful' : 'Import Failed'}
          </span>
        </div>

        {result.summary && (
          <div className="mb-3 text-sm text-green-700">
            <p><strong>Summary:</strong></p>
            <ul className="ml-4 list-disc">
              <li>Restaurants created: {result.summary.restaurants_created}</li>
              <li>Menus created: {result.summary.menus_created}</li>
              <li>Menu items created: {result.summary.menu_items_created}</li>
            </ul>
          </div>
        )}

        {result.logs && result.logs.length > 0 && (
          <div className="mb-3">
            <p className="text-sm font-medium text-gray-700 mb-1">Logs:</p>
            <div className="max-h-32 overflow-y-auto text-xs bg-gray-50 p-2 rounded">
              {result.logs.map((log, index) => (
                <div key={index} className={`mb-1 ${log.type === 'error' ? 'text-red-600' : 'text-gray-600'}`}>
                  <strong>[{log.type?.toUpperCase() || 'INFO'}]</strong> {log.message}
                </div>
              ))}
            </div>
          </div>
        )}

        {result.errors && result.errors.length > 0 && (
          <div className="text-sm text-red-700">
            <p><strong>Errors:</strong></p>
            <ul className="ml-4 list-disc">
              {result.errors.map((error, index) => (
                <li key={index}>{error}</li>
              ))}
            </ul>
          </div>
        )}

        {result.error && (
          <div className="text-sm text-red-700">
            <strong>Error:</strong> {result.error}
          </div>
        )}
      </div>
    )
  }

  return (
    <div className="bg-white rounded-lg shadow-sm border p-6">
      <h2 className="text-2xl font-bold mb-6" style={{ color: "rgb(10, 32, 47)" }}>Admin Panel - JSON Import</h2>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <div className="space-y-3">
          <h3 className="text-lg font-medium" style={{ color: "rgb(10, 32, 47)" }}>Import via JSON Text</h3>
          <textarea
            value={jsonInput}
            onChange={(e) => setJsonInput(e.target.value)}
            placeholder={`Paste your JSON here, e.g.:
{
  "restaurants": [
    {
      "name": "My Restaurant",
      "menus": [
        {
          "name": "Dinner Menu",
          "menu_items": [
            {"name": "Pasta", "price": 15.99}
          ]
        }
      ]
    }
  ]
}`}
            className="w-full h-48 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 font-mono text-sm resize-none"
            style={{ 
              "--tw-ring-color": "rgb(81, 226, 239)",
              "--tw-ring-opacity": "0.5"
            } as any}
          />
          <button
            onClick={handleJsonSubmit}
            disabled={loading || !jsonInput.trim()}
            className="w-full px-4 py-2 text-white rounded-md hover:opacity-80 disabled:opacity-50 disabled:cursor-not-allowed font-medium"
            style={{ backgroundColor: "rgb(81, 226, 239)" }}
          >
            {loading ? 'Importing...' : 'Import JSON'}
          </button>
        </div>

        <div className="space-y-3">
          <h3 className="text-lg font-medium" style={{ color: "rgb(10, 32, 47)" }}>Import via File Upload</h3>
          <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center hover:border-gray-400 transition-colors h-48 flex flex-col justify-center">
            <input
              type="file"
              accept=".json,application/json"
              onChange={handleFileChange}
              className="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-medium file:text-white hover:file:opacity-80 mb-2"
              style={{ 
                "fileBackgroundColor": "rgb(81, 226, 239)"
              } as any}
            />
            <p className="text-sm text-gray-500">
              {selectedFile ? `Selected: ${selectedFile.name}` : 'Choose a JSON file to upload'}
            </p>
          </div>
          <button
            onClick={handleFileSubmit}
            disabled={loading || !selectedFile}
            className="w-full px-4 py-2 text-white rounded-md hover:opacity-80 disabled:opacity-50 disabled:cursor-not-allowed font-medium"
            style={{ backgroundColor: "rgb(66, 6, 24)" }}
          >
            {loading ? 'Uploading...' : 'Upload File'}
          </button>
        </div>
      </div>

      {renderResult()}

      <div className="mt-8 p-4 rounded-md" style={{ backgroundColor: "rgba(81, 226, 239, 0.1)" }}>
        <h4 className="text-sm font-medium mb-2" style={{ color: "rgb(10, 32, 47)" }}>JSON Format Example:</h4>
        <pre className="text-xs overflow-x-auto" style={{ color: "rgb(10, 32, 47)" }}>
{`{
  "restaurants": [
    {
      "name": "Example Restaurant",
      "menus": [
        {
          "name": "Main Menu",
          "menu_items": [
            {"name": "Burger", "price": 12.99},
            {"name": "Pizza", "price": 18.50}
          ]
        }
      ]
    }
  ]
}`}
        </pre>
      </div>
    </div>
  )
}