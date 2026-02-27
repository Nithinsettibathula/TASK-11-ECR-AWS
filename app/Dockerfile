# STEP 1: Build Stage
FROM node:18-alpine AS build

# Install build dependencies + postgres libraries for the build
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    libtool \
    zlib-dev \
    libpng-dev \
    nasm \
    bash \
    vips-dev \
    postgresql-client \
    libpq-dev

WORKDIR /opt/app

# Copy package files
COPY package.json package-lock.json ./

# This downloads the 'pg' driver mentioned in your package.json
RUN npm install

# Copy code and build Strapi
COPY . .
RUN npm run build


# STEP 2: Production Stage
FROM node:18-alpine

# Install ONLY the runtime library for postgres (libpq)
RUN apk add --no-cache vips-dev libpq

WORKDIR /opt/app

# Copy the built application from the build stage
COPY --from=build /opt/app ./

EXPOSE 80

# Production start
CMD ["npm", "run", "start"]