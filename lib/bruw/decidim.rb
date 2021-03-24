module Bruw
  class Decidim
    def self.version
      raise StandardError, 'Not in Decidim project' unless decidim_app?

      parse_gem_version
    end

    # Returns version between parentheses from gem info output
    def self.parse_gem_version
      @decidim_version[/\(([^()]*)\)/, 1]
    end

    def self.decidim_app?
      !get_current_decidim.nil? && !get_current_decidim.empty?
    end

    def self.get_current_decidim
      @decidim_version ||= `gem info decidim | grep decidim`
    end
  end
end
