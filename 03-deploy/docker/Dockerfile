FROM php:8.3-fpm-alpine
RUN apk add --no-cache --virtual .build $PHPIZE_DEPS \
 && docker-php-ext-install opcache \
 && apk del .build
