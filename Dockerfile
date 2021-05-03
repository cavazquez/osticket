FROM php:7.3-apache

ENV DEBIAN_FRONTEND=noninteractive 
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt update && apt-get install -y libpng-dev libc-client-dev libkrb5-dev libicu-dev libxml2-dev wget unzip && rm -rf /var/lib/apt/lists/* 

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap 
RUN docker-php-ext-configure intl  && docker-php-ext-install intl 
RUN docker-php-ext-install gd mbstring xml mysqli  
RUN pecl install apcu && docker-php-ext-enable apcu
RUN docker-php-ext-install opcache 

RUN echo "Alias /osticket /var/www/osticket" > /etc/apache2/sites-available/osticket.conf
ENV version="v1.15.2"
RUN wget -q https://github.com/osTicket/osTicket/releases/download/${version}/osTicket-${version}.zip && unzip -q osTicket-${version}.zip -d ostmp && mv ostmp/upload/ /var/www/osticket && rm -rf ostmp/ osTicket-${version}.zip
COPY es_AR.phar /var/www/osticket/include/i18n/es_AR.phar

RUN a2dissite 000-default default-ssl && a2ensite osticket.conf 
