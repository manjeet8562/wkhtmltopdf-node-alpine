# docker-wkhtmltopdf-node-alpine
This repository is explaining how wkhtmltopdf can be implemented in docker container based deployment for the Node Alpine images for Features like HTML to PDF Generation

# Dockerfile
```
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
```
### Explanation

This docker file is a multi stage deployment and it uses [surnet-wkhtmltopdf](https://github.com/surnet/docker-wkhtmltopdf/pkgs/container/alpine-node-wkhtmltopdf#surnetalpine-node-wkhtmltopdf) for the wkhtmltopdf installation and keep them as small as possible while delivering all functions. You can read more about it [Here](https://github.com/surnet/docker-wkhtmltopdf/pkgs/container/alpine-node-wkhtmltopdf#surnetalpine-node-wkhtmltopdf).

#### Set Library path on index.js for Windows and Ubuntu if needed
> Note: `wkhtmltopdf.command = '/usr/bin/wkhtmltopdf'` is required for referencing to wkhtmltopdf, In ubuntu you generally don't need that but for windows you have to specify it before using.


### Commands 

Follow these below commands to test it on local for the HTML to PDF Generation


#### Without docker image

```sh
cd wkhtmltopdf-node-alpine
npm i
npm run start
```

#### With docker image

```sh
docker build -t wkhtmlhtml-to-pdf .
```
```sh
docker run -it -p 3000:3000 wkhtmlhtml-to-pdf
```
#### Test with endpoint for the PDF Generation

> http://localhost:3000/generate-pdf




---

## License
MIT License

Copyright (c) 2024 Manjeet

## Author
**Manjeet**  
- [GitHub](https://github.com/manjeet8562) 
- [LinkedIn](https://www.linkedin.com/in/manjeet-sharma-46083a122)