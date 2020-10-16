FROM nginx:1.19.3-alpine

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/nginx/certificates

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certificates/key.pem -out /etc/nginx/certificates/cert.pem -subj "/C=AT/ST=Moscow/L=Moscow/O=Security/OU=Development/CN=cq.local"

ADD local/default.conf /etc/nginx/conf.d/default.conf

ADD 'local/ssl/cq.local+1.pem' /etc/nginx/certificates
ADD 'local/ssl/cq.local+1-key.pem' /etc/nginx/certificates

WORKDIR /var/www