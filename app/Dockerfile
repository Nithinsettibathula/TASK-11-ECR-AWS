# STEP 1: Build Stage
FROM node:18-alpine AS build

# Fix memory issues and provide dummy build secrets
ENV NODE_OPTIONS="--max-old-space-size=2048"
ENV NODE_ENV=production
ENV APP_KEYS="testKey1,testKey2"
ENV API_TOKEN_SALT="testSalt"
ENV ADMIN_JWT_SECRET="testAdminSecret"
ENV JWT_SECRET="testJwtSecret"

RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev postgresql-client libpq-dev

WORKDIR /opt/app
COPY package.json package-lock.json ./

# 'npm ci' is better for Docker than 'npm install'
RUN npm ci

COPY . .
# Force a clean build
RUN npm run build

# STEP 2: Production Stage
FROM node:18-alpine
RUN apk add --no-cache vips-dev libpq
WORKDIR /opt/app

# Copy only the necessary files from build stage
COPY --from=build /opt/app ./

EXPOSE 80
CMD ["npm", "run", "start"]