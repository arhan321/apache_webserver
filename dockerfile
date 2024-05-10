FROM php:8.1-apache

WORKDIR /var/www/html

# Install PDO MySQL and other required dependencies
RUN apt-get update -y \
    && apt-get install -y libmariadb-dev \
    && docker-php-ext-install pdo_mysql

# Install mysqli extension (jika diperlukan)
RUN docker-php-ext-install mysqli

# Copy Apache vhost configuration
COPY httpd.vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules and set permissions
RUN a2enmod rewrite \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Set "Require all granted" in vhost configuration
RUN sed -i 's/Require .*/Require all granted/' /etc/apache2/sites-available/000-default.conf

# Restart Apache
RUN service apache2 restart
