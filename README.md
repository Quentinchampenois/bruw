# Bruw CLI

Simple CLI for daily commands when working with Decidim projects.

### Requirements

* Ruby >= 2.5 - recommended
* Thor
* Colorize
* Rubocop

### Commands

#### bruw

Top level command, allows to define multiple subcommands

#### bruw datshit
[Rspecdatshit](https://gist.github.com/armandfardeau/054f1869d4c15a3394129ca048232889) written by Armand Fardeau, was refactored to be used with Thor gem 

It allows to execute tests modified using Rspec. It is based on git status modified files

Usage:

Print Decidim ruby version
```
bruw datshit version
```

List modified tests in project
```
bruw datshit list
```

Execute rspec on modified tests in project
```
bruw datshit exec
```

Get help about a specific command
```
bruw datshit help [exec|list|version]
```

