# Restaurant Menu

[Kanban Project Issue Roadmap](https://github.com/users/Carolis/projects/2/views/1?sortedBy%5Bdirection%5D=asc&sortedBy%5BcolumnId%5D=Labels)

[Online Interface Demo](https://menu-frontend-production.up.railway.app)

[API Production URL](https://menu-backend-production-bf53.up.railway.app/api/v1/restaurants)

## Architecture

- **Backend**: Ruby on Rails 8.0.2.1 (API-only) with PostgreSQL
- **Frontend**: React 18 with TypeScript, built using Vite
- **Database**: PostgreSQL
- **Deployment**: Railway

## Prerequisites

- Ruby 3.4.4
- Node.js 18+ and npm
- PostgreSQL 14+

## Local Development Setup

### 1. Clone and Setup Backend

```bash
cd backend

bundle install

rails db:create
rails db:migrate

rails db:seed

rails server -p 3001
```

Backend will be available at: `http://localhost:3001`

### 2. Setup Frontend

```bash
cd frontend

npm install

npm run dev
```

Frontend will be available at: `http://localhost:5173`

## Environment Variables

### Backend (.env)

```
DATABASE_URL=postgresql://username:password@localhost/restaurant_menu_development
RAILS_ENV=development
```

### Frontend (.env.local)

```
VITE_API_URL=http://localhost:3001/api/v1
```

## Testing

### Backend Tests

```bash
cd backend
bundle exec rspec
```

### Frontend Tests

```bash
cd frontend
npm run test
```

# API Endpoint usage examples

## Get all restaurants (No Auth required)

```
curl "https://menu-backend-production-bf53.up.railway.app/api/v1/restaurants" | jq '.[0] | {name: .name, menus_count: (.menus | length)}'
```

## Get specific restaurant (No Auth required)

```
curl "https://menu-backend-production-bf53.up.railway.app/api/v1/restaurants/1" | jq '{name: .name, menus: [.menus[] | {name: .name, items: [.menu_items[].name]}]}'
```

## Create new restaurant (No Auth required)

```
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/restaurants" \
  -H "Content-Type: application/json" \
  -d '{"restaurant": {"name": "Test Production Restaurant"}}'
```

## Admin Auth

Admin endpoints require HTTP Basic Authentication. Default credentials for the DEMO:

- Username: `admin`
- Password: `password`

Set custom credentials via environment variables:

- `ADMIN_USERNAME` - Custom admin username
- `ADMIN_PASSWORD` - Custom admin password

### Test Admin Authentication

```
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/auth/verify" \
  -u admin:password \
  -H "Content-Type: application/json"
```

Expected response:

```json
{
  "authenticated": true,
  "message": "Authentication successful"
}
```

## Get all menus

```
curl "https://menu-backend-production-bf53.up.railway.app/api/v1/menus" | jq '.[0] | {name: .name, restaurant: .restaurant_id, items_count: (.menu_items | length)}'
```

## Get specific menu

```
curl "https://menu-backend-production-bf53.up.railway.app/api/v1/menus/1" | jq '{menu_name: .name, items: [.menu_items[] | {name: .name, price: .price}]}'
```

## Get all menu items

```
curl "https://menu-backend-production-bf53.up.railway.app/api/v1/menu_items" | jq '[.[] | {name: .name, price: .price, appears_on_menus: [.menus[].name]}]'
```

## JSON Import (Requires Auth)

**All import endpoints require admin authentication**

### Test with valid JSON data

```bash
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/import/restaurants" \
  -u admin:password \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "restaurants": [
        {
          "name": "Production Test Restaurant",
          "menus": [
            {
              "name": "test menu",
              "menu_items": [
                {"name": "Production Test Item", "price": 12.50}
              ]
            }
          ]
        }
      ]
    }
  }' | jq '{success: .success, summary: .summary, logs: .logs | length}'
```

### Test error handling - missing restaurant name

```bash
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/import/restaurants" \
  -u admin:password \
  -H "Content-Type: application/json" \
  -d '{"data": {"restaurants": [{"menus": []}]}}' | jq '{success: .success, errors: .errors}'
```

### Test error handling - invalid JSON

```bash
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/import/restaurants" \
  -u admin:password \
  -H "Content-Type: application/json" \
  -d '{"data": "invalid json structure"}' | jq '{success: .success, error: .error}'
```

### Test without authentication (should fail)

```bash
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/import/restaurants" \
  -H "Content-Type: application/json" \
  -d '{"data": {"restaurants": []}}'
```

Expected response: `HTTP Basic: Access denied.`

## Create a test file

```

echo '{
"restaurants": [{
"name": "File Upload Test Restaurant",
"menus": [{
"name": "upload test menu",
"menu_items": [{"name": "Upload Test Item", "price": 9.99}]
}]
}]
}' > test_restaurant.json
```

## Upload the file (with authentication)

```bash
curl -X POST "https://menu-backend-production-bf53.up.railway.app/api/v1/import/restaurants" \
  -u admin:password \
  -F "file=@test_restaurant.json" | jq '{success: .success, summary: .summary}'
```

## Production Deployment Instructions (Railway)

### Backend Deployment

1. Create new Railway service, connect your repository
2. Add required gems: `bundle add thruster rack-cors`
3. Set environment variables in Railway dashboard:
   - `RAILS_ENV=production`
   - `SECRET_KEY_BASE=<generate with: rails secret>`
   - `FRONTEND_URL=<your-frontend-public-railway-url>`
4. Deploy automatically via git push

### Frontend Deployment

1. Create separate Railway service for frontend
2. Add `.nvmrc` file with content: `20`
3. Set environment variables:
   - `VITE_API_URL=<your-backend-public-railway-url>/api/v1`
4. Deploy automatically via git push

### Railway Configuration Friendly Reminders

- Use **public URLs** for CORS configuration
- Node.js 20+ required for Vite 7
- Thruster gem required for Rails 8 deployment
