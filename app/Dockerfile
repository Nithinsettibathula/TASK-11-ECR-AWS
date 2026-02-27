# STEP 1: Build Stage
FROM node:18-alpine AS build

# Increase memory for the build process
ENV NODE_OPTIONS="--max-old-space-size=2048"

# Dummy variables needed ONLY for the build phase
ENV NODE_ENV=production
ENV DATABASE_CLIENT=postgres
ENV APP_KEYS="testKey1,testKey2"
ENV API_TOKEN_SALT="testSalt"
ENV ADMIN_JWT_SECRET="testAdminSecret"
ENV JWT_SECRET="testJwtSecret"

RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev postgresql-client libpq-dev

WORKDIR /opt/app
COPY package.json package-lock.json ./

# Use 'npm ci' for a clean, reliable build in Docker
RUN npm ci

COPY . .
# Run build with the production environment set
RUN npm run build

# STEP 2: Production Stage
FROM node:18-alpine
RUN apk add --no-cache vips-dev libpq
WORKDIR /opt/app

# Copy the built application from the build stage
COPY --from=build /opt/app ./

EXPOSE 80
CMD ["npm", "run", "start"]