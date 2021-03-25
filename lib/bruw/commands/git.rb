# frozen_string_literal: true

require "thor"

module Bruw
  module Commands
    class Git < Thor
      desc "remotes", "Get all current git remotes"
      long_desc <<-LONGDESC
        Get all current git remotes
      LONGDESC
      def remotes
        puts Bruw::Git.remotes
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "prune [PATTERN]", "Prune all git remotes"
      long_desc <<-LONGDESC
        This command will remove all git remotes except origin

        Params:

        PATTERN - String :: Allows to find remote where name begins by the PATTERN specified :: DEFAULT 'decidim-'
      LONGDESC
      def prune(pattern = "decidim-")
        prompt = TTY::Prompt.new

        remotes = Bruw::Git.remotes(pattern)
        raise StandardError, "No git remotes to remove" unless remotes.count.positive?

        puts "Found remotes :"
        puts remotes
        raise StandardError, "bruw decidim prune canceled" unless prompt.yes?("Do you really want to prune #{remotes.count.to_s.colorize(:green)} remotes ?")

        Bruw::Git.prune_remotes(remotes)
        puts "Remotes successfully removed !".colorize(:green)
      rescue StandardError => e
        puts e.message.colorize(:red)
      end
    end
  end
end
