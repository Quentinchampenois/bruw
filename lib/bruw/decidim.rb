# frozen_string_literal: true

module Bruw
  class Decidim
    def self.version
      raise StandardError, "Not in Decidim project" unless decidim_app?

      current_version
    end

    # curl allows to curl a specific file in the target repository
    # Params:
    # settings : Hash
    #   owner : String - Repository owner
    #   repo : String - Repository name
    #   version : String - Specific Decidim version
    #   path : String - Target file relative path
    def self.curl(settings = {})
      base_url = github_repo_base(settings[:owner], settings[:repo], settings[:version])
      uri = "#{base_url}/#{settings[:path]}"
      content = curl_response parse_uri(uri)
      raise StandardError, "No content for specified path : \n> #{uri}" if content.nil? || content.empty?

      content
    end

    def self.parse_uri(uri)
      URI.parse uri
    end

    def self.decidim_app?
      !current_version.nil? && !current_version.empty?
    end

    def self.osp_app?
      !Dir.exist?("decidim-core") && !Dir.exist?("decidim-admin") && !Dir.exist?("decidim-initiatives")
    end

    def self.github_repo_base(owner, repo, version)
      owner = "decidim" if owner.nil? || owner.empty?
      repo = "decidim" if repo.nil? || repo.empty?
      version = "v#{current_version}" if version.nil? || version.empty?

      "https://raw.githubusercontent.com/#{owner}/#{repo}/#{version}"
    end

    def self.current_version
      lines = File.open("Gemfile.lock")
      decidim_version = ""
      lines.each do |line|
        next unless /decidim \((?!=).+/i =~ line

        idx = line.strip.chars.index("(")

        decidim_version = line.strip[idx + 1..line.strip.size - 2] unless idx.nil?
      end

      decidim_version
    end

    def self.curl_response(uri)
      response = Net::HTTP.get_response(uri)
      response&.body if response.is_a?(Net::HTTPOK) && response.respond_to?(:body)
    end
  end
end
