#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE}

if [ "$role" = "app" ]; then

  exec php-fpm

elif [ "$role" = "queue-default" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=default --verbose --tries=1 --timeout=600

  done

elif [ "$role" = "queue-images" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=images --verbose --tries=1 --timeout=600

  done

elif [ "$role" = "queue-notifications" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=notifications --verbose --tries=1 --timeout=600

  done

elif [ "$role" = "queue-analitics" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=analitics --verbose --tries=1 --timeout=600

  done

elif [ "$role" = "queue-websockets" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=websockets --verbose --tries=1 --timeout=600

  done

elif [ "$role" = "queue-emails" ]; then
  sleep 10
  while [ true ]; do
    echo "Running the queue..."
    php /var/www/artisan queue:work --queue=emails --verbose --tries=1 --timeout=0

  done

elif [ "$role" = "scheduler" ]; then
  sleep 10
  while [ true ]; do
    php /var/www/artisan schedule:run --verbose
    sleep 60
  done

elif [ "$role" = "abios" ]; then
  echo "Sleeping..."
  sleep 40
  echo "Abios Started..."
  php /var/www/artisan abios:sync

elif [ "$role" = "odds" ]; then
  echo "Sleeping..."
  sleep 40
  echo "Odds Started..."
  php /var/www/artisan odds:run

fi
