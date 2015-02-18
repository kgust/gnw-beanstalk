# GoNorth! Websites – Beanstalk and Queue Worker
FROM ubuntu:14.04.1
MAINTAINER Straight North Dev <dev@straightnorth.com>

ENV DEBIAN_FRONTEND noninteractive
ENV APP_ENV dev

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php5-5.6 && \
    apt-get update && \
    apt-get upgrade -y --force-yes && \
    apt-get install -y --force-yes \
    libmcrypt4 \
    libpcre3-dev \
    nodejs-legacy \
    npm \
    ruby-dev \
    php5-apcu \
    php5-cli  \
    php5-curl \
    php5-dev \
    php5-gd \
    php5-gmp \
    php5-json \
    php5-mcrypt \
    php5-mysql \
    supervisor && \
    gem install jekyll && \
    npm install -g less && \
    mkdir -p /data/www && \
    mkdir -p /data/logs && \
    rm -rf /var/lib/apt-lists/* && \
    sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

# Define working directory.
# WORKDIR /data/www
WORKDIR /etc/supervisor/conf.d

# Define mountable directories.
VOLUME ["/etc/supervisor/conf.d"]

ADD 80-beanstalkd.conf .
ADD 90-queue-worker.conf .

EXPOSE 11300

# Define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
