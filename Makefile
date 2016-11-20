IMAGE_NAME=debian/molly

run:
	rebar3 release
	./_build/default/rel/mollypictures/bin/mollypictures console

docker: permissions
	rebar3 as prod release
	# build docker image
	docker build -t ${IMAGE_NAME} .

permissions:
	# ensure that executables are executable
	chmod +x config/docker/my_init.d/*
	chmod -R +x config/docker/runit/*
