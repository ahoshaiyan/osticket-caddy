FROM php:8.2-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

RUN apk add --no-cache git supervisor autoconf openssl-dev g++ make pcre-dev icu-dev zlib-dev libzip-dev linux-headers
RUN docker-php-ext-install bcmath intl opcache zip mysqli
RUN apk del --purge autoconf g++ make
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN git clone -b 1.18.x https://github.com/osTicket/osTicket /app

COPY ./Caddyfile /etc/caddy/Caddyfile
COPY supervisord-apps.ini /etc/supervisor.d/

CMD ["supervisord", "-n"]
