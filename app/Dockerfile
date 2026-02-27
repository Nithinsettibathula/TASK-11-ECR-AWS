# Use Node 18 Alpine for a small, secure image
FROM node:18-alpine

# Install build dependencies for Strapi
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev

# Set environment
ENV NODE_ENV=production

# Install dependencies
WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install --only=production

# --- CRITICAL FIX: Explicitly install the PostgreSQL driver ---
RUN npm install pg --save
# --------------------------------------------------------------

ENV PATH /opt/node_modules/.bin:$PATH

# Copy application code and build
WORKDIR /opt/app
COPY . .
RUN npm run build

# Expose the Strapi port
EXPOSE 1337

# Start the application
CMD ["npm", "run", "start"]