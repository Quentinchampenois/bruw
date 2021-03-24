# Testing bruw gem

Bruw command is tested using [Rspec](https://github.com/rspec/rspec) and [Aruba](https://github.com/cucumber/aruba)

## Functional tests

Functional tests are defined under `features` folder. To run this tests, use `cucumber` gem as following : 

```sh
bundle exec cucumber features/bruw.features
``` 

## Unit tests

Unit tests are defined under `spec` folder. There defined to work with `rspec` gem.

To run tests with rspec, use `rspec` as following: 

```sh
bundle exec rspec spec
```


