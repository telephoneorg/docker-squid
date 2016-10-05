NS = vp
NAME = squid
APP_VERSION = 3.5.19
IMAGE_VERSION = 1.0
VERSION = $(APP_VERSION)-$(IMAGE_VERSION)
LOCAL_TAG = $(NS)/$(NAME):$(VERSION)

REGISTRY = callforamerica
ORG = vp
REMOTE_TAG = $(REGISTRY)/$(NAME):$(VERSION)

GITHUB_REPO = docker-squid
DOCKER_REPO = squid
BUILD_BRANCH = master


.PHONY: all build test release shell run start stop rm rmi default

all: build

checkout:
	@git checkout $(BUILD_BRANCH)

build:
	@docker build -t $(LOCAL_TAG) --rm .
	$(MAKE) tag

tag:
	@docker tag $(LOCAL_TAG) $(REMOTE_TAG)

rebuild:
	@docker build -t $(LOCAL_TAG) --rm --no-cache .

test:
	@rspec ./tests/*.rb

commit:
	@git add -A .
	@git commit

clean-data:
	@-rm -rf data/*

push:
	@git push origin master

shell:
	@docker exec -ti $(NAME) /bin/ash

run:
	@docker run -it --rm --name $(NAME) $(LOCAL_TAG) ash

launch:
	@docker run -d --name $(NAME) -p "3128:3128" $(LOCAL_TAG)

launch-net:
	@docker run -d --name $(NAME) -p "3128:3128" --network=local $(LOCAL_TAG)

launch-persist:
	@docker run -d --name $(NAME) -v "$(shell pwd)/data:/var/cache/squid" -p "3128:3128" $(LOCAL_TAG)

create-network:
	@docker network create -d bridge local

logs:
	@docker logs $(NAME)

logsf:
	@docker logs -f $(NAME)

start:
	@docker start $(NAME)

kill:
	-@docker kill $(NAME)

stop:
	-@docker stop $(NAME)

rm:
	-@docker rm $(NAME)

rmi:
	@docker rmi $(LOCAL_TAG)
	@docker rmi $(REMOTE_TAG)

rmf:
	@docker rm --force $(NAME)

default: build