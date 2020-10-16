exec:
	docker-compose exec php-fpm $$cmd

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-compose-build:
	docker-compose up --build -d

docker-build: docker-compose-build odds-stop abios-stop echo-stop

setup-local: composer-install npm-install npm-dev storage-link key-generate nova-publish search-fast cache

setup-dev: composer-install npm-install npm-prod storage-link key-generate nova-publish search-fast cache

setup-prod: composer-install-prod npm-install npm-prod storage-link key-generate nova-publish search cache

bash:
	make exec cmd="bash"

nova-publish:
	make exec cmd="php artisan nova:publish"
	make exec cmd="php artisan vendor:publish --tag=nova-froala-field-plugins --provider=App\\Providers\\Froala\\FroalaFieldServiceProvider"

queue-restart:
	make exec cmd="php artisan queue:restart"

abios-stop:
	make exec cmd="php artisan abios:pause"
	docker stop abios

abios-start:
	make exec cmd="php artisan abios:unpause"
	docker start abios

odds-stop:
	docker stop odds

redis-keys-size:
	./docker/mysql/scripts/redis-keys-size.sh

odds-start:
	docker start odds

docker-build-nginx:
	docker-compose up -d --no-deps --build nginx

docker-build-php:
	docker-compose up -d --no-deps --build php-fpm

docker-build-mysql:
	docker-compose up -d --no-deps --build mysql


echo-stop:
	docker stop echo

echo-start:
	docker start echo

optimize-wpcontent:
	make exec cmd="php artisan optimize:wpcontent"

opcache-compile:
	make exec cmd="php artisan opcache:compile"

storage-link:
	make exec cmd="php artisan storage:link"

series-canonical:
	make exec cmd="php artisan series:canonical"

key-generate:
	make exec cmd="php artisan key:generate"

test: cache
	make exec cmd="vendor/bin/phpunit"
t:
	make exec cmd="php artisan test:test"

migrate:
	make exec cmd="php artisan migrate"

abios-sync:
	make exec cmd="php artisan abios:sync"

sitemap-generate:
	make exec cmd="php artisan sitemap:generate -v"

composer-update:
	make exec cmd="composer update"

composer-update-prod:
	make exec cmd="composer update --no-dev"

composer-install:
	make exec cmd="composer install"

composer-install-prod:
	make exec cmd="composer install --no-dev"

composer-dump:
	make exec cmd="composer dump-autoload"

npm-install:
	make exec cmd="npm install"

log-php:
	docker logs --tail 50 -f laravel

log-mysql:
	docker logs --tail 50 -f mysql

log-abios:
	docker logs --tail 50 -f abios

log-odds:
	docker logs --tail 50 -f odds

log-echo:
	docker logs --tail 50 -f echo

log-nginx:
	docker logs --tail 50 -f nginx

log-queue-default:
	docker logs --tail 50 -f queue-default

log-queue-images:
	docker logs --tail 50 -f queue-images

log-queue-emails:
	docker logs --tail 50 -f queue-emails

log-queue-notifications:
	docker logs --tail 50 -f queue-notifications

log-queue-analitics:
	docker logs --tail 50 -f queue-analitics

log-queue-websockets:
	docker logs --tail 50 -f queue-websockets

log-scheduler:
	docker logs --tail 50 -f laravel-scheduler

purge-html:
	make exec cmd="php artisan purge:html"

npm-dev:
	make exec cmd="npm run dev"

npm-prod: purge-html
	make exec cmd="npm run prod"

npm-prod-cache: npm-prod cache

npm-watch:
	make exec cmd="npm run watch"

cache: cqcc queue-restart

cache-lite: cqcc

cqcc:
	make exec cmd="php artisan cq:cache"

tipsters-stats:
	make exec cmd="php artisan tipsters:stats"

odds-seed:
	make exec cmd="php artisan db:seed --class=OddsSeed"

badges-seed:
	make exec cmd="php artisan db:seed --class=BadgesSeed"

outcomes-seed:
	make exec cmd="php artisan db:seed --class=OutcomesSeed"

odds-dump:
	make exec cmd="php artisan odds:dump"

eearnings-update:
	make exec cmd="php artisan eearnings:update"

elastic-show:
	curl -XGET 'localhost:9201/_cat/indices?v&pretty'

update-streakswr:
	make exec cmd="php artisan update:streakswr"

update-tournaments-media:
	make exec cmd="php artisan abios:updateTournamentsMedia"

elo-update-ranks:
	make exec cmd="php artisan elo:update-ranks"

elo-build-history-dota:
	make exec cmd="php artisan elo:build-history dota-2"

elo-build-history-cs:
	make exec cmd="php artisan elo:build-history cs-go"

elo-build-history-lol:
	make exec cmd="php artisan elo:build-history lol"

update-wingg:
	make exec cmd="php artisan wingg:update -v"

elo-build-history-ow:
	make exec cmd="php artisan elo:build-history overwatch"

search:
	make exec cmd="php artisan search:update"

search-fast:
	make exec cmd="php artisan search:update fast"

update-teams:
	make exec cmd="php artisan update:teams"

cosplaygram:
	make exec cmd="php artisan job:cosplaygram"

backup-db:
	bash ~/backups/backup-db.sh
	bash docker/mysql/scripts/zip-db.sh

backup-wp-content:
	bash docker/mysql/scripts/backup-wp-content.sh

backup-uploads:
	bash docker/mysql/scripts/backup-uploads.sh

get-wp-content:
	bash docker/mysql/scripts/get-wp-content.sh

get-uploads:
	bash docker/mysql/scripts/get-uploads.sh

restore-uploads:
	bash docker/mysql/scripts/restore-uploads.sh

perm:
	sudo chown -R www-data:www-data .
	sudo chmod -R 775  .

get-db:
	bash docker/mysql/scripts/get-db.sh

restore-db:
	docker-compose exec php-fpm bash /var/www/docker/mysql/scripts/unzip.sh
	docker-compose exec mysql bash /var/www/docker/mysql/scripts/restore-db.sh