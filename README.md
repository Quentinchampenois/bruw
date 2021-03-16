# Bruw CLI

Simple CLI for daily commands when working with Decidim projects.

### Requirements

* Ruby >= 2.5 - recommended
* Thor
* Colorize
* Rubocop

### Getting started

Export current folder to your `PATH`. It allows you to call the command `bruw` from everywhere.

```
export $PATH=$PATH:$(pwd)
```

#### Remove bruw from your PATH

If you want to remove the bruw folder from your path, you can : 

```
echo $PATH

output: <bin_folder>:<other_bin_folder>:<bruw_folder>
```

So you can just remove the path to the bruw project from the string, and then update the variable `$PATH`

```
export $PATH=<bin_folder>:<other_bin_folder>
```

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

