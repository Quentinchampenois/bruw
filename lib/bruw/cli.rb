# frozen_string_literal: true

require "bruw"

module Bruw
  class CLI < Thor
    desc "version", "Get the current cli version"
    def version
      puts VERSION
    end

    desc "zip TARGET DESTINATION", "Compress target"
    def zip(target, destination = ".")
      target = Bruw::Base.strip_path(target)
      dest = Bruw::Base.strip_path(destination)
      final = "#{dest}/#{target}.zip"

      raise StandardError, "File already existing : #{final}" if File.exist?(final)

      Bruw::Base.create_path(dest) unless Dir.exist?(dest)

      `zip -r #{final} #{target}`
      puts "Compression finished, find file at".colorize(:green)
      puts "> #{final}"
    rescue StandardError => e
      puts e.message.colorize(:red)
    end

    desc "unzip TARGET", "Compress target"
    def unzip(target)
      raise StandardError, "File '#{target}' does not exists" unless File.exist?(target)

      `unzip #{target}`
      puts "Decompression finished, find file at".colorize(:green)
      puts "> #{target}"
    rescue StandardError => e
      puts e.message.colorize(:red)
    end

    desc "decidim SUBCOMMAND ...ARGS", "Manage Decidim projects"
    subcommand "decidim", Bruw::Commands::Decidim

    desc "git SUBCOMMAND ...ARGS", "Manage Git projects"
    subcommand "git", Bruw::Commands::Git
  end
end
