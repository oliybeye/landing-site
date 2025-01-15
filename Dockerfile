# Step 1: Use a Node.js image to build the app
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (forcing install to handle potential conflicts)
RUN npm install --legacy-peer-deps

# Copy the rest of the application files
COPY . .

# Build the React app for production
RUN npm run build

# Step 2: Use a lightweight Nginx server to serve the built files
FROM nginx:1.23-alpine

# Copy the production build from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 to the host
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
