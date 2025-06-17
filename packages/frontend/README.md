# Frontend Package

React/TypeScript frontend application built with Next.js, featuring modern UI components and state management.

## 🏗️ Architecture

- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: Redux Toolkit
- **Data Fetching**: React Query (TanStack Query)
- **UI Components**: Headless UI + Radix UI
- **Icons**: Heroicons
- **Forms**: React Hook Form + Zod validation
- **Testing**: Jest + React Testing Library
- **Linting**: ESLint + Prettier

## 🚀 Quick Start

### Prerequisites

- Node.js >= 18.0.0
- Backend service running (for API calls)

### Installation

1. Install dependencies:
   ```bash
   pnpm install
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your API endpoints
   ```

3. Start development server:
   ```bash
   pnpm dev
   ```

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

## 📁 Project Structure

```
packages/frontend/
├── src/
│   ├── app/              # Next.js App Router pages
│   ├── components/       # Reusable UI components
│   │   ├── ui/           # Base UI components
│   │   └── forms/        # Form components
│   ├── hooks/            # Custom React hooks
│   ├── lib/              # Utility libraries
│   ├── store/            # Redux store configuration
│   ├── types/            # TypeScript type definitions
│   └── utils/            # Utility functions
├── public/               # Static assets
├── tailwind.config.js    # Tailwind CSS configuration
├── next.config.js        # Next.js configuration
├── package.json
└── tsconfig.json
```

## 🛠️ Available Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm start` - Start production server
- `pnpm test` - Run tests
- `pnpm test:watch` - Run tests in watch mode
- `pnpm lint` - Run ESLint
- `pnpm lint:fix` - Fix ESLint issues
- `pnpm type-check` - Run TypeScript type checking

## 🔧 Configuration

### Environment Variables

- `NEXT_PUBLIC_API_URL` - Backend API URL
- `NEXT_PUBLIC_APP_URL` - Frontend application URL
- `NEXTAUTH_SECRET` - NextAuth.js secret
- `NEXTAUTH_URL` - NextAuth.js URL

### Key Features

- **Authentication**: NextAuth.js with JWT
- **Responsive Design**: Mobile-first approach
- **Dark Mode**: Toggle between light and dark themes
- **Internationalization**: i18n support
- **PWA**: Progressive Web App capabilities
- **SEO**: Optimized for search engines

## 🎨 UI Components

The frontend uses a component library built with:

- **Tailwind CSS** for styling
- **Headless UI** for accessible components
- **Radix UI** for complex UI primitives
- **Heroicons** for icons

### Component Examples

```tsx
// Button component
<Button variant="primary" size="lg">
  Click me
</Button>

// Form component
<Form>
  <FormField name="email" label="Email" type="email" />
  <FormField name="password" label="Password" type="password" />
</Form>
```

## 🧪 Testing

```bash
# Run all tests
pnpm test

# Run tests with coverage
pnpm test:coverage

# Run specific test file
pnpm test -- src/components/Button.test.tsx
```

## 📱 Responsive Design

The application is built with a mobile-first approach:

- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

## 🔒 Security

- CSRF protection
- XSS prevention
- Content Security Policy (CSP)
- Secure headers
- Input sanitization

## 🚀 Performance

- **Code Splitting**: Automatic with Next.js
- **Image Optimization**: Next.js Image component
- **Font Optimization**: Next.js font optimization
- **Bundle Analysis**: Webpack bundle analyzer
- **Lighthouse**: Performance monitoring

## 📊 Analytics

- Google Analytics integration
- Custom event tracking
- Performance monitoring
- Error tracking with Sentry

## 🌐 Internationalization

Support for multiple languages:

- English (default)
- Spanish
- French
- German

## 📚 Documentation

- Component documentation with Storybook
- API documentation
- Design system guidelines 