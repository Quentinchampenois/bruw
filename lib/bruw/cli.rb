# frozen_string_literal: true

require "bruw"

module Bruw
  class CLI < Thor
    desc "version", "Get the current cli version"
    def version
      puts VERSION
    end

    desc "decidim SUBCOMMAND ...ARGS", "Manage Decidim projects"
    subcommand "decidim", Bruw::Commands::Decidim

    desc "git SUBCOMMAND ...ARGS", "Manage Git projects"
    subcommand "git", Bruw::Commands::Git
  end
end
