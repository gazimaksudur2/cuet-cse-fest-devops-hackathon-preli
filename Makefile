DOCKER_COMPOSE ?= docker compose

DEV_COMPOSE := docker/compose.development.yaml
PROD_COMPOSE := docker/compose.production.yaml

MODE ?= dev          # dev | prod
SERVICE ?=           # optional: backend, gateway, mongo
ARGS ?=

ifeq ($(MODE),prod)
COMPOSE_FILE := $(PROD_COMPOSE)
else
COMPOSE_FILE := $(DEV_COMPOSE)
endif

# -------- Core targets --------
up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) --env-file .env up $(ARGS) $(SERVICE)

down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) --env-file .env down $(ARGS)

build:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) --env-file .env build $(SERVICE)

logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f $(SERVICE)

restart:
	$(MAKE) down MODE=$(MODE) SERVICE=$(SERVICE)
	$(MAKE) up MODE=$(MODE) SERVICE=$(SERVICE) ARGS="--build"

shell:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) exec $(if $(SERVICE),$(SERVICE),backend) sh

ps:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

# -------- Dev aliases --------
dev-up:
	$(MAKE) up MODE=dev ARGS="--build"

dev-down:
	$(MAKE) down MODE=dev

dev-build:
	$(MAKE) build MODE=dev

dev-logs:
	$(MAKE) logs MODE=dev

dev-restart:
	$(MAKE) restart MODE=dev

dev-shell:
	$(MAKE) shell MODE=dev SERVICE=backend

# -------- Prod aliases --------
prod-up:
	$(MAKE) up MODE=prod ARGS="-d --build"

prod-down:
	$(MAKE) down MODE=prod ARGS="-v"

prod-build:
	$(MAKE) build MODE=prod

prod-logs:
	$(MAKE) logs MODE=prod

prod-restart:
	$(MAKE) restart MODE=prod

# -------- Cleanup / misc --------
clean:
	-$(DOCKER_COMPOSE) -f $(DEV_COMPOSE) down -v
	-$(DOCKER_COMPOSE) -f $(PROD_COMPOSE) down -v

status: ps

help:
	@echo "Usage:"
	@echo "  make dev-up       # start dev (build + up)"
	@echo "  make dev-down     # stop dev"
	@echo "  make prod-up      # start prod (detached)"
	@echo "  make prod-down    # stop prod + volumes"
	@echo "  make logs SERVICE=gateway MODE=dev # logs"
	@echo "  make shell SERVICE=backend MODE=dev # shell into container"
