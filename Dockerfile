FROM debian:bullseye

MAINTAINER Josh King <jking@chambana.net>

RUN apt-get update && \
        apt-get -y upgrade && \
	apt-get install -y --no-install-recommends ca-certificates \
          uwsgi-plugin-php php-curl php-json \
          unzip wget php-xml && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENV PODCASTGEN_VERSION 3.2.9

EXPOSE 8080

VOLUME ["/var/www"]

ADD podcastgen.conf /etc/uwsgi/apps-available/podcastgen.conf

## Add startup script.
ADD bin/run.sh /app/bin/run.sh
RUN chmod 0755 /app/bin/run.sh

ENTRYPOINT ["/app/bin/run.sh"]
CMD ["uwsgi", "--uid", "www-data", "--gid", "www-data", "--ini", "/etc/uwsgi/apps-available/podcastgen.conf"]
