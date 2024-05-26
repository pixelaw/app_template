PROFILE ?= dev

build:
	sozo --profile $(PROFILE) build;

test:
	sozo --profile $(PROFILE) test;

deploy_new: reset deploy
	scarb --profile $(PROFILE) run initialize;
	scarb --profile $(PROFILE) run upload_manifest;
	@echo "PixeLAW should be back at http://localhost:3000 again."

deploy_local:
	docker run -it --rm -v $(shell pwd):/mounted ghcr.io/pixelaw/core:0.3.6 /bin/sh -c "/pixelaw/tools/local_deploy.sh"


deploy: build
	sozo --profile $(PROFILE) migrate;

dev:
	sozo --profile $(PROFILE) dev --name pixelaw;

reset:
	docker compose down -v;
	docker compose up -d;

shell:
	docker compose exec pixelaw-core bash;

log_katana:
	docker compose exec pixelaw-core /bin/bash klog

log_torii:
	docker compose exec pixelaw-core tail -f /keiko/log/torii.log

log_bots:
	docker compose exec pixelaw-core tail -f /keiko/log/bots.log