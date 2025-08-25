# Restaurant Menu

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

## Production Deployment (Railway)

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

### Railway Configuration Friendly Reminders! 
- Use **public URLs** for CORS configuration
- Node.js 20+ required for Vite 7
- Thruster gem required for Rails 8 deployment

## API Endpoints (TBD)
