# frozen_string_literal: true

module Bruw
  class Decidim
    def self.version
      raise StandardError, 'Not in Decidim project' unless decidim_app?

      parse_gem_version
    end

    # Returns version between parentheses from gem info output
    def self.parse_gem_version
      @current_version[/\(([^()]*)\)/, 1]
    end

    def self.decidim_app?
      !current_version.nil? && !current_version.empty?
    end

    def self.current_version
      @current_version ||= `gem info decidim | grep decidim`
    end
  end
end
