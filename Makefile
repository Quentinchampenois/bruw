.DEFAULT_GOAL := build

NAME=bruw-0.1.0.gem

install:
	gem install pkg/$(NAME)

rake_build:
	bundle exec rake build

build:
	@make rake_build
	@make install
