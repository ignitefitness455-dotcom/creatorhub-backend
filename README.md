# CreatorHub Backend API

A comprehensive backend API for CreatorHub - a creative tools platform with PDF processing, image editing, AI-powered content generation, and business tools.

## Features

### Authentication & User Management
- JWT-based authentication with refresh tokens
- Email verification
- Password reset
- OAuth (Google, GitHub) support
- User profiles and avatars

### File Processing
- **PDF Tools**: Merge, Split, Compress, Convert to Images, Rotate, E-Signature
- **Image Tools**: Compress, Upscale, Convert, Remove Background, Extract Colors
- AWS S3 integration with presigned URLs
- File storage with plan-based limits

### AI-Powered Tools
- Hashtag Generator (GPT-4)
- Caption Writer
- Bio Generator
- Content Ideas Generator
- Video Script Generator

### Business Tools
- QR Code Generator (Text, WiFi, vCard)
- Invoice Generator (PDF)
- EMI Calculator
- Password Generator

### Payments & Subscriptions
- Stripe integration
- Multiple plans: Free, Basic ($9.99/mo), Pro ($29.99/mo), Enterprise ($99.99/mo)
- Subscription management
- Payment history
- Customer portal

### Queue System
- BullMQ with Redis for background processing
- Job tracking and status updates
- Automatic cleanup

### Security
- Rate limiting per plan tier
- Helmet security headers
- CORS protection
- Input validation
- SQL injection protection (Prisma)

## Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Cache/Queue**: Redis with BullMQ
- **File Storage**: AWS S3 / Cloudflare R2
- **AI**: OpenAI GPT-4
- **Payments**: Stripe
- **Email**: Resend (SMTP)

## Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- Redis 6+
- AWS S3 or Cloudflare R2 account
- Stripe account (for payments)
- OpenAI API key (for AI features)
- Resend API key (for emails)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd creatorhub-backend
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your credentials
```

4. Set up the database:
```bash
npx prisma migrate dev
npx prisma generate
```

5. Seed the database:
```bash
npm run db:seed
```

6. Start the development server:
```bash
npm run dev
```

The API will be available at `http://localhost:5000`

## Environment Variables

```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/creatorhub"

# JWT
JWT_SECRET="your-super-secret-jwt-key"
JWT_REFRESH_SECRET="your-super-secret-refresh-key"

# AWS S3
AWS_ACCESS_KEY_ID="your-aws-key"
AWS_SECRET_ACCESS_KEY="your-aws-secret"
AWS_REGION="us-east-1"
AWS_S3_BUCKET="creatorhub-uploads"

# Redis
REDIS_URL="redis://localhost:6379"

# OpenAI
OPENAI_API_KEY="sk-..."

# Stripe
STRIPE_SECRET_KEY="sk_test_..."
STRIPE_WEBHOOK_SECRET="whsec_..."
STRIPE_PRICE_BASIC="price_..."
STRIPE_PRICE_PRO="price_..."
STRIPE_PRICE_ENTERPRISE="price_..."

# Email
RESEND_API_KEY="re_..."

# App
NODE_ENV="development"
PORT=5000
FRONTEND_URL="http://localhost:5173"
```

## API Documentation

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login user |
| GET | `/api/auth/verify-email` | Verify email |
| POST | `/api/auth/refresh-token` | Refresh access token |
| GET | `/api/auth/me` | Get current user |
| POST | `/api/auth/logout` | Logout user |

### Files

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/files/upload-url` | Generate presigned upload URL |
| POST | `/api/files/upload` | Upload file directly |
| GET | `/api/files` | List user's files |
| GET | `/api/files/:id` | Get file details |
| GET | `/api/files/:id/download` | Get download URL |
| DELETE | `/api/files/:id` | Delete file |

### PDF Tools

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tools/pdf/merge` | Merge multiple PDFs |
| POST | `/api/tools/pdf/split` | Split PDF by pages |
| POST | `/api/tools/pdf/compress` | Compress PDF |
| POST | `/api/tools/pdf/convert-to-images` | Convert PDF to images |
| POST | `/api/tools/pdf/rotate` | Rotate PDF pages |

### Image Tools

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tools/image/compress` | Compress image |
| POST | `/api/tools/image/upscale` | Upscale image |
| POST | `/api/tools/image/convert` | Convert image format |
| POST | `/api/tools/image/remove-background` | Remove background |
| POST | `/api/tools/image/extract-colors` | Extract color palette |

### AI Tools

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tools/ai/hashtags` | Generate hashtags |
| POST | `/api/tools/ai/caption` | Generate caption |
| POST | `/api/tools/ai/bio` | Generate bio |
| POST | `/api/tools/ai/content-ideas` | Generate content ideas |
| POST | `/api/tools/ai/video-script` | Generate video script |

### Business Tools

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tools/business/qr-code` | Generate QR code |
| POST | `/api/tools/business/invoice` | Generate invoice PDF |
| POST | `/api/tools/business/emi` | Calculate EMI |
| POST | `/api/tools/business/password` | Generate password |

### Payments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/payments/plans` | Get available plans |
| POST | `/api/payments/checkout` | Create checkout session |
| POST | `/api/payments/portal` | Create customer portal |
| GET | `/api/payments/subscription` | Get subscription status |
| GET | `/api/payments/history` | Get payment history |

## Plan Limits

| Feature | Free | Basic | Pro | Enterprise |
|---------|------|-------|-----|------------|
| PDF Operations | 5/mo | 50/mo | 500/mo | Unlimited |
| Image Operations | 10/mo | 100/mo | 1000/mo | Unlimited |
| AI Operations | 3/mo | 25/mo | 200/mo | Unlimited |
| Storage | 500MB | 5GB | 50GB | 500GB |
| Max File Size | 10MB | 50MB | 100MB | 500MB |
| Price | Free | $9.99/mo | $29.99/mo | $99.99/mo |

## Scripts

```bash
# Development
npm run dev          # Start with hot reload

# Production
npm run build        # Build TypeScript
npm start            # Start production server

# Database
npm run db:generate  # Generate Prisma client
npm run db:migrate   # Run migrations
npm run db:studio    # Open Prisma Studio
npm run db:seed      # Seed database
```

## Deployment

### Docker

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 5000

CMD ["npm", "start"]
```

### Railway / Render

1. Connect your GitHub repository
2. Add environment variables
3. Deploy!

### AWS ECS / EC2

1. Build Docker image
2. Push to ECR
3. Deploy to ECS or EC2

## Monitoring

Health check endpoint: `GET /health`

Response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "services": {
    "database": "connected",
    "redis": "connected"
  },
  "version": "1.0.0"
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details

## Support

For support, email support@creatorhub.com or join our Discord community.
