# Backend Package

Node.js/TypeScript backend service with Express.js and microservices architecture.

## 🏗️ Architecture

- **Framework**: Express.js with TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Caching**: Redis
- **Authentication**: JWT with Passport.js
- **API Documentation**: Swagger/OpenAPI
- **Testing**: Jest with Supertest
- **Validation**: Joi or Zod
- **Logging**: Winston
- **Monitoring**: Prometheus metrics

## 🚀 Quick Start

### Prerequisites

- Node.js >= 18.0.0
- PostgreSQL
- Redis

### Installation

1. Install dependencies:
   ```bash
   pnpm install
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your database and Redis configuration
   ```

3. Run database migrations:
   ```bash
   pnpm db:migrate
   ```

4. Start development server:
   ```bash
   pnpm dev
   ```

## 📁 Project Structure

```
packages/backend/
├── src/
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # Database models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── utils/           # Utility functions
│   ├── types/           # TypeScript type definitions
│   └── app.ts           # Express app setup
├── prisma/              # Database schema and migrations
├── tests/               # Test files
├── package.json
└── tsconfig.json
```

## 🛠️ Available Scripts

- `pnpm dev` - Start development server with hot reload
- `pnpm build` - Build for production
- `pnpm start` - Start production server
- `pnpm test` - Run tests
- `pnpm test:watch` - Run tests in watch mode
- `pnpm lint` - Run ESLint
- `pnpm lint:fix` - Fix ESLint issues
- `pnpm db:migrate` - Run database migrations
- `pnpm db:seed` - Seed database with sample data
- `pnpm db:reset` - Reset database

## 🔧 Configuration

### Environment Variables

- `PORT` - Server port (default: 3001)
- `NODE_ENV` - Environment (development/production)
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `JWT_SECRET` - JWT signing secret
- `CORS_ORIGIN` - Allowed CORS origins

### API Endpoints

- `GET /health` - Health check
- `GET /api/v1/users` - Get users
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration

## 🧪 Testing

```bash
# Run all tests
pnpm test

# Run tests with coverage
pnpm test:coverage

# Run specific test file
pnpm test -- src/controllers/user.test.ts
```

## 📊 Monitoring

The backend includes Prometheus metrics and health checks:

- `GET /metrics` - Prometheus metrics
- `GET /health` - Health check endpoint

## 🔒 Security

- JWT-based authentication
- Password hashing with bcrypt
- CORS configuration
- Rate limiting
- Input validation
- SQL injection prevention with Prisma

## 📚 API Documentation

API documentation is available at `/api-docs` when running in development mode. 