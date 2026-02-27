# STEP 1: Build Stage
FROM node:18-alpine AS build

# Added 'postgresql-client' and 'libpq' for SQL support
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

# Install dependencies including the pg driver
RUN npm install

# Copy code and build
COPY . .
RUN npm run build


# STEP 2: Production Stage
FROM node:18-alpine

# Install ONLY the runtime libraries for vips and postgres
RUN apk add --no-cache vips-dev libpq

WORKDIR /opt/app

# Copy the built application from the build stage
COPY --from=build /opt/app ./

# Expose port 80 for the ALB
EXPOSE 80

# Production start
CMD ["npm", "run", "start"]