require 'thor'
require 'bruw'

module Bruw
  class CLI < Thor
    desc "version", "Get the current cli version"
    def version
      puts VERSION
    end
  end
end
