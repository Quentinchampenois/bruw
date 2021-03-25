# Add a subcommand to Bruw

All gem's logic is located under `lib/` folder. 

For now there is no generator, but it could be an interesting feature. Furthermore, maybe the gem structure will change because I am not persuaded by the current structure. 

## Getting started

Let's imagine we create the subcommand `toto`.

### Create library

First of all, I define the dedicated library for the `toto` logic.

    $ touch lib/bruw/toto.rb

In `toto.rb`, I define the core of my library to be used in the following subcommand.

```
#lib/bruw/toto.rb
# frozen_string_literal: true

module Bruw
  class Toto
    def self.my_name_is
      "My name is Toto"
    end
  end
end
```

### Create subcommand

Then you can create the wanted subcommand under `lib/bruw/commands/` as following

    $ touch lib/bruw/commands/toto.rb
    
And insert the Thor command you want

```
#lib/bruw/commands/toto.rb
# frozen_string_literal: true

require 'thor'

module Bruw
  module Commands
    class Toto < Thor
      desc "name", "Returns my current name"
      long_desc <<-LONGDESC
        Returns the current name
      LONGDESC
      def name
        puts Bruw::Toto.my_name_is
      end
    end
  end
end
```

### Register the library and subcommand

Now you can add your library to the current command

Add the following `require` to the file `lib/bruw.rb`
```
require "bruw/toto"
require "bruw/commands/toto"
```

And the create your new subcommand in `lib/bruw/cli.rb`

```
#lib/bruw/cli.rb
# frozen_string_literal: true

require "bruw"

module Bruw
  class CLI < Thor
    desc "version", "Get the current cli version"
    def version
      puts VERSION
    end

    desc "toto SUBCOMMAND ...ARGS", "Simple toto subcommand !"
    subcommand "toto", Bruw::Commands::Toto
  end
end
```

## Congratulations !

You should now be able to run the command `bundle exec exe/bruw toto name` !

Example : 

```
    $ bundle exec exe/bruw toto name
    output: My name is Toto
```

## More information

You can install the gem without publishing it nor make a new release if you want to test the command line from outside project. To do so, just install the gem locally, for example 

    $ make
    
