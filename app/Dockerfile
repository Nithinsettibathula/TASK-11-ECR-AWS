# STEP 1: Build Stage
FROM node:18-alpine AS build
RUN apk update && apk add --no-cache build-base gcc autoconf automake libtool zlib-dev libpng-dev nasm bash vips-dev postgresql-client libpq-dev
WORKDIR /opt/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# STEP 2: Production Stage
FROM node:18-alpine
RUN apk add --no-cache vips-dev libpq
WORKDIR /opt/app
# Copy everything including the installed node_modules from the build stage
COPY --from=build /opt/app ./
EXPOSE 80
CMD ["npm", "run", "start"]