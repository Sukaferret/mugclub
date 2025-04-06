FROM php:8.1-apache

# Install system dependencies
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

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install Composer
COPY --# Move Laravel public files to Apache root
RUN cp -r public/* . && rm -rf public

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader || true

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 80

CMD ["apache2-foreground"]
