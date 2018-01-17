FROM ubuntu:16.04

RUN echo "deb http://ppa.launchpad.net/ondrej/nginx/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/ondrej-ubuntu-nginx-xenial.list ; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E5267A6C ; \
    apt-get update ; \
    apt-get install -y nginx-extras luajit libmagickwand-dev luarocks ca-certificates ; \
    sync ; sync ;sync ; \
    luarocks install magick ; \
    luarocks install lua-resty-http ; \
    apt-get clean; apt-get autoclean; \
    rm -rf /var/lib/apt/lists/*

#Creating Directory Structure

RUN [ -d /etc/nginx/lua ] || mkdir -p /etc/nginx/lua && \
    [ -d /var/www/nginx-imageproxy ] || mkdir -p /var/www/nginx-imageproxy ; \
    chown -R www-data:www-data /var/www/nginx-imageproxy ; \
    unlink /etc/nginx/sites-enabled/default

# Using prebaked config files since there are alot of variables to be changed.

ADD files/nginx/lua/imageproxy-crop.lua /etc/nginx/lua/
ADD files/nginx/lua/imageproxy-zoomcrop.lua /etc/nginx/lua/
ADD files/nginx/lua/imageproxy-resize.lua /etc/nginx/lua/
ADD files/nginx/sites-enabled/default /etc/nginx/sites-enabled/

ADD files/entry.sh /tmp/entry.sh
RUN chmod 777 /tmp/entry.sh

EXPOSE 80

ENTRYPOINT /tmp/entry.sh

