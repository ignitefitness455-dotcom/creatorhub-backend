# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install all dependencies (including dev)
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma client and build
RUN npx prisma generate && npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Install system dependencies for Sharp
RUN apk add --no-cache \
    vips-cpp \
    libjpeg-turbo \
    libpng \
    tiff \
    giflib \
    ca-certificates

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install production dependencies only
RUN npm ci --only=production --ignore-scripts && \
    npm rebuild sharp --platform=linuxmusl --arch=x64 && \
    npx prisma generate

# Copy built files from builder
COPY --from=builder /app/dist ./dist

# Create temp upload directory
RUN mkdir -p uploads/temp

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5000/health || exit 1

# Start the server
CMD ["npm", "start"]
