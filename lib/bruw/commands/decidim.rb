# frozen_string_literal: true

module Bruw
  module Commands
    class Decidim < Thor
      desc 'version', 'Get the current decidim version'
      def version
        puts Bruw::Decidim.version
      rescue StandardError => e
        puts e.message.colorize(:red)
      end
    end
  end
end
