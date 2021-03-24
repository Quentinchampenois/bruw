# frozen_string_literal: true

module Bruw
  module Commands
    class Decidim < Thor
      desc 'version', 'Get the current decidim version'
      def version
        puts "Current Decidim version is #{Bruw::Decidim.version&.colorize(:green)}"
      rescue StandardError => e
        puts e.message.colorize(:red)
      end
    end
  end
end
