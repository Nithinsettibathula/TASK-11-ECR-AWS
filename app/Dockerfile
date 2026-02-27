# STEP 1: Build Stage
FROM node:18-alpine AS build
# Adding extra memory limit for node to prevent build crashes
ENV NODE_OPTIONS="--max-old-space-size=2048"

RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev postgresql-client libpq-dev

WORKDIR /opt/app
COPY package.json package-lock.json ./

# Clean install to ensure no conflicts
RUN npm ci

COPY . .
# Running build with production flag
RUN npm run build

# STEP 2: Production Stage
FROM node:18-alpine
RUN apk add --no-cache vips-dev libpq

WORKDIR /opt/app
COPY --from=build /opt/app ./

EXPOSE 80
CMD ["npm", "run", "start"]