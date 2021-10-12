# frozen_string_literal: true

require "bruw"

module Bruw
  class CLI < Thor
    desc "version", "Get the current cli version"
    def version
      puts VERSION
    end

    desc "zip TARGET DESTINATION", "Compress target"
    option :tar, required: false, banner: "Use tar, zip by default", aliases: "-t", type: :boolean, default: false
    def zip(target, destination = ".")
      target = Bruw::Base.strip_path(target)
      dest = Bruw::Base.strip_path(destination)
      extension = if options[:tar]
                    "tar.gz"
                  else
                    "zip"
                  end
      final = "#{dest}/#{target}.#{extension}"

      raise StandardError, "File already existing : #{final}" if File.exist?(final)

      Bruw::Base.create_path(dest) unless Dir.exist?(dest)

      `tar -zcf #{final} #{target}` if options[:tar]
      `zip -r #{final} #{target}` unless options[:tar]

      puts "Compression finished !".colorize(:green)
      puts "> #{final}"
    rescue StandardError => e
      puts e.message.colorize(:red)
    end

    desc "unzip TARGET", "Decompress and unpack target"
    option :zip, required: false, banner: "Force decompression with zip", aliases: "-z", type: :boolean, default: false
    option :tar, required: false, banner: "Force decompression with tar", aliases: "-t", type: :boolean, default: false
    def unzip(target)
      raise StandardError, "File '#{target}' does not exists" unless File.exist?(target)

      if target.end_with?(".zip") || options[:zip]
        `unzip #{target}`
      elsif target.end_with?(".tar.gz") || options[:tar]
        `tar -zxf #{target}`
      else
        raise StandardError, "Unknown tool to use"
      end

      puts "Decompression finished !".colorize(:green)
    rescue StandardError => e
      puts e.message.colorize(:red)
    end

    desc "decidim SUBCOMMAND ...ARGS", "Manage Decidim projects"
    subcommand "decidim", Bruw::Commands::Decidim

    desc "git SUBCOMMAND ...ARGS", "Manage Git projects"
    subcommand "git", Bruw::Commands::Git

    desc "fs SUBCOMMAND ...ARGS", "Manage filesystem"
    subcommand "fs", Bruw::Commands::Fs
  end
end
