FROM node:23

# Set the working directory
WORKDIR /usr/src/app

# Copy the application files
COPY . .

# Install dependencies
RUN npm install

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["node", "notes.js"]