FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -yqq

RUN apt-get install -yqq erlang
RUN apt-get install -yqq imagemagick

COPY _build/prod /app

EXPOSE 8080

CMD ["/app/rel/mollypictures/bin/mollypictures", "foreground"]
