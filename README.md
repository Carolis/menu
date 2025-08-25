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

## API Endpoints (TBD)
