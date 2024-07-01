FROM php:8.3-apache

# Apache mod_rewrite
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/

# ミドルウェアインストール
RUN apt-get update \
    && apt-get install -y \
    nano vim wget \
    zip unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libpng-dev \
    libmcrypt-dev \
    libicu-dev \
    libpq-dev \
    cron \
    zlib1g-dev \
    libonig-dev \
    imagemagick \
    libmagickwand-dev \
    libmagickcore-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mysqli \
    pdo \
    intl \
    zip \
    opcache

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install imagick from source
RUN apt-get update \
    && apt-get install -y git build-essential \
    && git clone https://github.com/Imagick/imagick.git /usr/src/imagick \
    && cd /usr/src/imagick \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/src/imagick

# Composer
RUN cd /usr/bin && curl -s http://getcomposer.org/installer | php && ln -s /usr/bin/composer.phar /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin

RUN composer self-update --2

# Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install MySQL client
RUN apt-get update \
    && apt-get install -y \
    default-mysql-client-core \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*
