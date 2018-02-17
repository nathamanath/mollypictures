FROM debian:stretch-slim

# App deps
RUN apt-get update && apt-get install -yq \
  openssl \
  gnupg2 \
  wget \
  imagemagick

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN rm erlang-solutions_1.0_all.deb
RUN apt-get update && apt-get install -yq esl-erlang

# Set the locale, otherwise elixir will complain later on
RUN apt-get purge locales
RUN apt-get install locales -yq
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Tidy up
RUN apt-get purge -yq wget
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash molly

# Move files over
COPY _build/prod /opt/mollypictures
RUN chown -R molly /opt/mollypictures

USER molly

EXPOSE 80

ENTRYPOINT /opt/mollypictures/rel/mollypictures/bin/mollypictures foreground
