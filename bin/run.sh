#!/bin/bash - 

. /app/lib/common.sh

CHECK_BIN "wget"
CHECK_BIN "unzip"
CHECK_BIN "uwsgi"
CHECK_VAR PODCASTGEN_VERSION

DIR=/var/www/PodcastGenerator-${PODCASTGEN_VERSION}
APPDIR=/var/www/PodcastGenerator

if [[ ! -d $APPDIR ]]; then
	MSG "Downloading podcastgen..."
	wget -O /tmp/podcastgen.zip \
          https://github.com/PodcastGenerator/PodcastGenerator/releases/download/v${PODCASTGEN_VERSION}/PodcastGenerator-${PODCASTGEN_VERSION}.zip
	[[ $? -eq 0 ]] || { ERR "Failed to download podcastgen, aborting."; exit 1; }
	unzip -o -d /var/www /tmp/podcastgen.zip
	[[ $? -eq 0 ]] || { ERR "Failed to unzip podcastgen, perhaps file is invalid?"; exit 1; }
	[[ -d $APPDIR ]] || { ERR "Directory $APPDIR does not exist, aborting."; exit 1; }
	chown -R www-data:www-data /var/www/
	sed -i -e "s#^php-docroot\ *=.*#php-docroot\ =\ ${APPDIR}#" \
		-e "s#^static-safe\ *=\ {{\ PODCASTGEN_DIR\ }}#static-safe\ =\ ${APPDIR}#" \
		/etc/uwsgi/apps-available/podcastgen.conf
fi

MSG "Serving site..."

exec "$@"
