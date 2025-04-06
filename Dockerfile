FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    sqlite3 \
    libsqlite3-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_sqlite \
    zip \
    bcmath \
    mbstring \
    xml

# Enable mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

# Laravel folders need correct permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 storage bootstrap/cache

# Move public files to web root (Apache serves from here)
RUN cp -r public/* . && rm -rf public

# 🔥 Composer install will run every time the container starts, ensuring vendor is always there
CMD composer install --no-dev --optimize-autoloader && apache2-foreground
