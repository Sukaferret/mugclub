FROM php:8.2-apache

# Install dependencies and PHP extensions
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

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Set permissions (important on Render)
RUN chown -R www-data:www-data /var/www/html

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel needs the storage and bootstrap/cache folders to be writable
RUN chmod -R 775 storage bootstrap/cache

# Copy Laravel's /public content to Apache root to avoid 403 errors on Render
RUN cp -r public/* .

# Expose web port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
