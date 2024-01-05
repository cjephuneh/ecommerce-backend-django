#!/usr/bin/env sh
set -ex

# Apply database migrations
python manage.py migrate --noinput

exec "$@"