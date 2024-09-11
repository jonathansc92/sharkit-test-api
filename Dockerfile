FROM php:8.2-apache

WORKDIR /app

# Copy the custom entrypoint script to the container
COPY /apache/custom-entrypoint.sh /usr/local/bin/custom-entrypoint
COPY /apache/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN apt update \
    && apt install -y zlib1g-dev libpng-dev libjpeg-dev libjpeg62-turbo-dev libfreetype6-dev git zip libzip-dev libicu-dev libonig-dev libpq-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pgsql pdo pdo_pgsql zip intl \
    && docker-php-ext-enable intl pdo_pgsql pgsql \
    && a2enmod rewrite headers proxy ssl proxy_http http2 alias \
    && chmod 755 /usr/local/bin/custom-entrypoint \
    && cd /usr/local/bin/ \
    # Install Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # Finish
    && echo 'End'

ENTRYPOINT [ "custom-entrypoint" ]

WORKDIR /var/www/html