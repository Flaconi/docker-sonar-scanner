DIR = .
FILE = Dockerfile
IMAGE = "flaconi/docker-sonar-scanner"
TAG = latest


pull:
	docker pull $(shell grep FROM Dockerfile | sed 's/^FROM//g';)

build:
	docker build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

rebuild: pull
	docker build --no-cache -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

test:
	./tests/test.sh $(IMAGE)

tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

login:
ifndef DOCKER_USER
	$(error DOCKER_USER must either be set via environment or parsed as argument)
endif
ifndef DOCKER_PASS
	$(error DOCKER_PASS must either be set via environment or parsed as argument)
endif
	yes | docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)

push:
	@$(MAKE) tag TAG=$(TAG)
	docker push $(IMAGE):$(TAG)

enter:
	docker run --rm --name $(subst /,-,$(IMAGE)) -it --entrypoint=bash $(ARG) $(IMAGE)
