# frozen_string_literal: true

module Bruw
  module Commands
    class Decidim < Thor
      desc 'version', 'Get the current decidim version'
      long_desc <<-LONGDESC
        Checks the Decidim version for the current project based on the bundler gem infos
      LONGDESC
      def version
        puts "Current Decidim version is #{Bruw::Decidim.version&.colorize(:green)}"
      rescue StandardError => e
        puts e.message.colorize(:red)
      end
    end
  end
end
