FROM node:12.18.3-alpine3.12 as builder

WORKDIR '/var/www/dashboard'

COPY package.json .
RUN npm install
COPY . .
RUN npm run build


FROM nginx
COPY --from=builder /var/www/dashboard/dist /usr/share/nginx/html
