# frozen_string_literal: true

require 'thor'
require "net/http"

module Bruw
  module Commands
    class Decidim < Thor
      desc "version", "Get the current decidim version"
      long_desc <<-LONGDESC
        Checks the Decidim version for the current project based on the bundler gem infos
      LONGDESC
      def version
        puts "Current Decidim version is #{Bruw::Decidim.version&.colorize(:green)}"
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "curl [RELATIVE_PATH]", "Curl given file against target github repository"
      long_desc <<-LONGDESC
        Allows to curl source code of specified path for a given version
      LONGDESC
      option :tag, required: false, banner: "Tag must have format vx.xx.x : Default current decidim version",
                   aliases: "-t", type: :string
      option :owner, required: false, banner: "Owner name : Default 'decidim'", aliases: "-o", type: :string
      option :repo, required: false, banner: "Repository name : Default 'decidim'", aliases: "-r", type: :string
      option :save, required: false, banner: "Save output in relative path", aliases: "-s", type: :boolean
      def curl(path)
        options[:path] = path
        options[:version] = options[:tag]

        response = Bruw::Decidim.curl(options)

        if options[:save]
          path = strip_path(path)
          create_path(path)
          save_file(path, response.chop)

          puts "Curl finished, please see '#{path}'".colorize(:green)
        else
          puts response.chop
        end
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      private

      def save_file(path, content)
        File.open(path, 'w') do |f|
          f.puts content
        end

        puts "File '#{path}' created.".colorize(:green)
      end

      def create_path(path)
        return if Dir.exist?(path)

        FileUtils.mkpath(File.dirname(path))
      end

      def strip_path(path)
        return path unless Bruw::Decidim.osp_app?

        path.split('/')[1..].join('/')
      end
    end
  end
end
