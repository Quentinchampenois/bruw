# frozen_string_literal: true

require "thor"

module Bruw
  module Commands
    class Fs < Thor
      class_option :verbose, type: :boolean, aliases: "-v"
      def self.exit_on_failure?
        true
      end

      desc "dockerinfo", "Get size of Docker on disk"
      def dockerinfo
        puts `docker system df`
      end

      desc "gmem", "Check the disk memory used"
      def gmem(path = ".")
        ary = Bruw::Fs.find_folder_size(path)

        if ary.empty?
          puts "
      An error occured

      Unable to check size of \"#{path}\".
      Please ensure this folder exists"
          exit
        end

        puts "Path \"#{ary[1]}\" weights #{ary[0]}"
      end

      desc "infos", "Display infos about global disk memory usage"
      def infos
        output = `df -h`

        puts output
      end

      desc "meminfos", "Display infos about a specific filesystem"
      def meminfos(diskname = "disk1s1")
        output = Bruw::Fs.meminfos(diskname)

        if output.nil? || output.empty?
          puts "An error occured

      Unable to find disk \"#{diskname}\".
      Please ensure this disk exists"
          exit
        end

        puts "Filesystem : #{output[:filesystem]}
Size : #{output[:size]}
Space used : #{output[:space_used]}
Space available : #{output[:space_available]}
capacity : #{output[:capacity]}
mounted_on : #{output[:mounted_on]}
             "
      end

      desc "listfs", "Display filesystems list"
      def listfs
        puts `df -h | cut -d" " -f1 | grep -v Filesystem`
      end
    end
  end
end
