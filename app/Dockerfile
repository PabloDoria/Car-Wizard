FROM php:8.2-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    gnupg2 libzip-dev zip unzip curl libxml2-dev libonig-dev \
    unixodbc-dev libcurl4-openssl-dev libssl-dev \
    && pecl install pdo_sqlsrv sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv sqlsrv \
    && docker-php-ext-install zip

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Copiar archivos al contenedor
COPY . /var/www/html/
WORKDIR /var/www/html/

# Permisos para Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Instalar dependencias Laravel
RUN composer install --no-interaction --optimize-autoloader

# Cache de configuración Laravel
RUN php artisan config:cache
