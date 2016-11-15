FROM debian

RUN apt-get update
RUN apt-get upgrade -yqq

RUN apt-get install -yqq erlang
RUN apt-get install -yqq imagemagick

###
# Nginx
RUN apt-get install -yqq nginx --fix-missing
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY ./config/docker/sites-available/default /etc/nginx/sites-available/default
RUN mkdir -p /var/log/mollypictures

COPY _build/prod /app
COPY config/docker/startup.sh /app/bin/startup.sh

ENTRYPOINT /app/bin/startup.sh
