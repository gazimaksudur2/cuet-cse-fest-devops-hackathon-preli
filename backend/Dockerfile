# backend/Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

# Install all deps (including dev) for TypeScript build
COPY package*.json tsconfig.json ./
RUN npm ci

# Copy source and build
COPY src ./src
RUN npm run build

# -------- Runtime image --------
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

# Install only production deps
COPY package*.json ./
RUN npm ci --omit=dev

# Copy compiled JS only
COPY --from=builder /app/dist ./dist

# Backend listens on BACKEND_PORT from env (3847)
EXPOSE 3847

CMD ["npm", "run", "start"]
