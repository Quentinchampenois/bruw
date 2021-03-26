# frozen_string_literal: true

module Bruw
  class Base
    def self.version
      "0.0.1"
    end

    def self.strip_path(path)
      return if path.nil? || path.empty?
      return path[0..-2] if path.end_with? "/"

      path
    end

    def self.create_path(path)
    return if Dir.exist?(path)

    FileUtils.mkpath(path)
    end
  end
end
