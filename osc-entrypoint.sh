#!/bin/bash
set -e

PORT="${PORT:-8080}"
APPDIR=/var/www/PodcastGenerator

# Apache listens on $PORT (OSC default 8080)
sed -i -E "s/^Listen .*/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i -E "s/<VirtualHost \*:[0-9]+>/<VirtualHost *:${PORT}>/" /etc/apache2/sites-available/000-default.conf

# Install Podcast Generator into the volume on first start only; existing
# installations (config, media, feed) on the volume are left untouched.
if [[ ! -d $APPDIR ]]; then
  echo "Installing Podcast Generator ${PODCASTGEN_VERSION} into /var/www..."
  unzip -q -o -d /var/www /opt/podcastgen.zip
  [[ -d $APPDIR ]] || { echo "Directory $APPDIR does not exist after unzip, aborting." >&2; exit 1; }
  chown -R www-data:www-data /var/www/
fi

exec "$@"
