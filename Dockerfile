# Stage 1: Build Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve Nginx
FROM nginx:stable
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
# NOTE: Ensure 'dist/softools/' matches your angular.json output path
COPY --from=build /app/dist/softools/ .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
