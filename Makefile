naem=ream
docker=docker

.PHONY: mini

kill:
	@$(info Killing all the Dockerfiles)
	@-$(docker) kill $$($(docker) ps -q)
	@-$(docker) rm $$($(docker) ps -a -q)
	@-$(docker) rmi $$($(docker) images -q)

build:
	$(docker) build --rm -f Dockerfile -t $(naem) .

mini:
	@-rm *_mini
	@-for f in BaseScripts/*.py;do BaseScripts/minifer.py $$f;done
	@-yes|rm -r mini
	@-mkdir mini
	@-mv BaseScripts/*_mini ./mini
	@-chmod 777 mini/*_mini

run: build
	#This exposes port 9000 from the host machine to port 8888 within the docker machine
	$(docker) run --rm -it  -v `pwd`:/sync $(naem) /bin/bash
	@make kill