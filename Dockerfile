# Build Stage
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code and build the frontend
COPY . .
RUN npm run build

# Production Stage
FROM node:20-alpine

WORKDIR /app

# Copy only the necessary files for the backend
COPY package*.json ./
RUN npm install --omit=dev

# Copy the server code and the built frontend
COPY --from=build /app/dist ./dist
COPY . .

# Expose the application port
EXPOSE 3001

# Start the application
CMD ["npm", "start"]
