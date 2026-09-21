# Build the React application
FROM node:14-alpine AS build

WORKDIR /app

# Install dependencies first to improve layer caching.
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN yarn build

# Serve the production build with nginx.
FROM nginx:1.27-alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
