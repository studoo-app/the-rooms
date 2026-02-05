FROM dunglas/frankenphp:latest

# Installation de SSH et autres outils
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN install-php-extensions \
	pdo_mysql \
	gd \
	intl \
	zip \
	opcache

# Installation de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /app

## Copier les fichiers de l'application
#COPY levels/level-07-webserver/app /app/
#
## Installation des dépendances Symfony (à décommenter si besoin)
#RUN composer install --no-interaction --optimize-autoloader
#
## Configuration des permissions
#RUN chown -R www-data:www-data /app && \
#    chmod -R 755 /app
#
## Exposer les ports
#EXPOSE 80
#
## Variables d'environnement Symfony
#ENV APP_ENV=dev \
#    SERVER_NAME=:80

