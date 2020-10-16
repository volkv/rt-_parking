FROM php:7.4.10-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libzip-dev \
    libxml2-dev \
    libcurl4-openssl-dev\
    libpng-dev \
    libxpm-dev \
    libvpx-dev

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs


RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /composer
RUN mkdir /npm
RUN chown www-data:www-data /npm
RUN chown www-data:www-data /composer


RUN npm set cache "/npm" -g

RUN npm i -g laravel-echo-server

RUN apt-get install locales
RUN echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen

# Install composer
ENV XDG_CONFIG_HOME /
ENV COMPOSER_HOME /composer
ENV COMPOSER_MEMORY_LIMIT -1
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
# Install extensions

RUN docker-php-ext-install pdo_mysql zip exif gd simplexml intl dom curl bcmath opcache pcntl
RUN pecl install redis && docker-php-ext-enable redis

COPY start.sh /usr/local/bin/start
RUN chmod u+x /usr/local/bin/start

COPY "php.ini" "/usr/local/etc/php/php.ini"

WORKDIR /var/www

USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["/usr/local/bin/start"]