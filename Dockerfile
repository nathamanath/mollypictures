FROM debian:jessie

RUN apt-get update
RUN apt-get upgrade -yqq

# Runit
RUN touch /etc/inittab
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q runit

# Nginx
RUN apt-get install -yqq nginx --fix-missing
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY ./config/docker/sites-available/default /etc/nginx/sites-available/default

# App deps
RUN apt-get install -yqq erlang
RUN apt-get install -yqq imagemagick

# Certbot
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install certbot -yq -t jessie-backports

# Cron
RUN apt-get install -y cron

# Tidy up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Move files over
COPY config/docker/my_init.d /etc/my_init.d
COPY config/docker/runit /etc/service
COPY _build/prod /app
COPY config/docker/bin /etc/docker/bin
COPY config/docker/bin/renew_cert.sh /etc/cron.weekly/renew_cert.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT /etc/docker/bin/startup.sh
