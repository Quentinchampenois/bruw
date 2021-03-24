.DEFAULT_GOAL := build

NAME=bruw-0.1.0.gem

install:
	bundle install

install_pkg:
	gem install pkg/$(NAME)

rake_build:
	bundle exec rake build

build:
	@make install
	@make rake_build
	@make install_pkg

cucumber:
	bundle exec cucumber features/*.features

rspec:
	bundle exec rspec spec

tests:
	@make cucumber
	@make rspec
