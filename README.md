# SaaS Platform

A comprehensive SaaS platform built with modern technologies, featuring a microservices backend, React frontend, Flutter mobile app, and cloud infrastructure.

## 🏗️ Project Structure

This is a monorepo containing the following packages:

- **`packages/backend`** - Node.js/TypeScript backend with Express.js and microservices architecture
- **`packages/frontend`** - React/TypeScript frontend with Next.js
- **`packages/mobile`** - Flutter mobile application
- **`packages/infrastructure`** - Terraform infrastructure as code for GCP

## 🚀 Quick Start

### Prerequisites

- Node.js >= 18.0.0
- pnpm >= 8.0.0
- Flutter SDK (for mobile development)
- Google Cloud SDK (for infrastructure)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd saas-platform
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

### Development

- **Start all services**: `pnpm dev`
- **Build all packages**: `pnpm build`
- **Run tests**: `pnpm test`
- **Lint code**: `pnpm lint`

### Individual Package Commands

- **Backend**: `pnpm --filter backend dev`
- **Frontend**: `pnpm --filter frontend dev`
- **Mobile**: `pnpm --filter mobile dev`
- **Infrastructure**: `pnpm --filter infrastructure plan`

## 📦 Package Details

### Backend
- Node.js with TypeScript
- Express.js framework
- Microservices architecture
- PostgreSQL database
- Redis caching
- JWT authentication

### Frontend
- React with TypeScript
- Next.js framework
- Tailwind CSS
- Redux Toolkit
- React Query

### Mobile
- Flutter with Dart
- Cross-platform (iOS/Android)
- State management with Provider/Riverpod
- Native device features

### Infrastructure
- Terraform for IaC
- Google Cloud Platform
- Kubernetes orchestration
- CI/CD pipelines

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions, please open an issue in the repository or contact the development team. 