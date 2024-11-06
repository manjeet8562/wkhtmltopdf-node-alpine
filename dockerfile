# Stage 1: Build wkhtmltopdf from ghcr.io/surnet/alpine-node-wkhtmltopdf
FROM ghcr.io/surnet/alpine-node-wkhtmltopdf:20.16.0-0.12.6-full as wkhtmltopdf_image

# Stage 2: Build the Node.js application
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install font and X11 dependencies for wkhtmltopdf
RUN apk --no-cache add \
    bash \
    freetype \
    freetype-dev \
    ttf-freefont \
    libxrender \
    libx11

# Copy wkhtmltopdf binaries and all necessary libraries from the previous stage
COPY --from=wkhtmltopdf_image /bin/wkhtmltopdf /usr/bin/wkhtmltopdf
COPY --from=wkhtmltopdf_image /bin/wkhtmltoimage /usr/bin/wkhtmltoimage
COPY --from=wkhtmltopdf_image /lib/libwkhtmltox* /usr/lib/
COPY --from=wkhtmltopdf_image /usr/lib/libX*.so.* /usr/lib/

# Install application dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of your application code
COPY . .

# Expose any ports your app uses
EXPOSE 3000

# Command to run your app
CMD ["npm", "start"]
