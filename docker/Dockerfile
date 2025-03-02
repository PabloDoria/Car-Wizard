# Usa una imagen oficial de PHP con Apache
FROM php:8.1-apache

# Instala extensiones necesarias para Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia los archivos de la aplicación Laravel al contenedor
WORKDIR /var/www/html
COPY app/. /var/www/html


# Instala dependencias de Laravel (si composer.json existe)
RUN if [ -f "composer.json" ]; then composer install --no-dev --optimize-autoloader; fi

# Crear las carpetas necesarias en caso de que no existan
RUN mkdir -p /var/www/html/storage/framework/{sessions,views,cache} \
    && mkdir -p /var/www/html/bootstrap/cache

# Establecer permisos adecuados
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache


# Exponer el puerto 80 para Apache
EXPOSE 80

# Inicia Apache
CMD ["apache2-foreground"]
