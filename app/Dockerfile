# STEP 1: Build Stage
FROM node:18-alpine AS build

# Increase memory for the build process
ENV NODE_OPTIONS="--max-old-space-size=2048"
ENV NODE_ENV=production

# These dummy variables keep the compiler happy during build
ENV APP_KEYS="testKey1,testKey2"
ENV API_TOKEN_SALT="testSalt"
ENV ADMIN_JWT_SECRET="testAdminSecret"
ENV JWT_SECRET="testJwtSecret"

RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev postgresql-client libpq-dev

WORKDIR /opt/app
COPY package.json package-lock.json ./

# Clean install
RUN npm ci

COPY . .

# Force the build and ignore TS errors in the build command
RUN npm run build

# STEP 2: Production Stage
FROM node:18-alpine
RUN apk add --no-cache vips-dev libpq
WORKDIR /opt/app

# Copy the built application
COPY --from=build /opt/app ./

EXPOSE 80
CMD ["npm", "run", "start"]