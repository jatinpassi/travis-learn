FROM node:12.18.3-alpine3.12 as builder

WORKDIR '/var/www/dashboard'

COPY package.json .
RUN npm install
COPY . .
RUN npm run build


FROM nginx
EXPOSE 80
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /var/www/dashboard/dist /usr/share/nginx/html
COPY --from=builder /var/www/dashboard/entrypoint.sh /usr/share/nginx/
# RUN chmod +x /usr/share/nginx/entrypoint.sh
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
