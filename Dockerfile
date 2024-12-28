# Build Stage
FROM node:22-slim as builder
WORKDIR /app

# Copy only necessary files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application files
COPY . .

# Build the application
RUN npm run build

# Runtime Stage
FROM node:22-slim
WORKDIR /app

# Copy built files and runtime dependencies
COPY --from=builder /app/build build/
COPY --from=builder /app/node_modules node_modules/
COPY --from=builder /app/package.json .

# Expose the application port
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production

# Command to run the application
CMD ["node", "build"]