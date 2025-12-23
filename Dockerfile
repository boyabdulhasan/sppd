FROM php:8.0-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip zip libpng-dev libonig-dev libxml2-dev \
    libzip-dev nodejs npm \
    && docker-php-ext-install pdo_mysql mbstring zip gd

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project
COPY . .

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port
EXPOSE 80

CMD ["apache2-foreground"]
