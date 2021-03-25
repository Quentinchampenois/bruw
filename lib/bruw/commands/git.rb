# frozen_string_literal: true

require "thor"

module Bruw
  module Commands
    class Git < Thor
      desc "remotes", "Get all current git remotes"
      long_desc <<-LONGDESC
        Get all current git remotes
      LONGDESC
      def remotes
        puts Bruw::Git.remotes
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "branch REMOTE BRANCH", "Get all current git remotes"
      long_desc <<-LONGDESC
        Get all current git remotes
      LONGDESC
      def branch(remote, branch)
        raise StandardError, "Not in git repository" unless Bruw::Git.git?

        Bruw::Git.fetch(remote)
        puts Bruw::Git.branch(remote, branch)
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "add-remote REPOSITORY", "Add new remote linked to github repository"
      long_desc <<-LONGDESC
        Add new remote linked to github repository
      LONGDESC
      option :owner, required: false, banner: "Owner of the specified remote", aliases: "-o", type: :string, default: "OpenSourcePolitics"
      def add_remote(repository)
        prompt = TTY::Prompt.new
        path = "#{options[:owner]}/#{repository}"
        return unless prompt.yes?("Adding remote #{repository} linked to repository : https://github.com/#{path}")

        `git remote add #{repository} git@github.com:#{path}.git`
        puts "Remote #{repository.colorize(:green)} successfully created"
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "prune [PATTERN]", "Prune all git remotes"
      long_desc <<-LONGDESC
        This command will remove all git remotes except origin

        Params:

        PATTERN - String :: Allows to find remote where name begins by the PATTERN specified :: DEFAULT 'decidim-'
      LONGDESC
      option :interactive, required: false, banner: "Run in interactive mode", aliases: "-i", type: :boolean
      def prune(pattern = "decidim-")
        prompt = TTY::Prompt.new

        remotes = Bruw::Git.remotes(pattern)

        raise StandardError, "No git remotes to remove" unless remotes.count.positive?

        if options[:interactive]
          remotes = prompt.multi_select("Select the git remote to remove", remotes)
        else
          puts "Found remotes :"
          puts remotes
        end

        raise StandardError, "bruw decidim prune canceled" unless prompt.yes?("Do you really want to prune #{remotes.count.to_s.colorize(:green)} remotes ?")

        Bruw::Git.prune_remotes(remotes)
        puts "Remotes successfully removed !".colorize(:green)
      rescue StandardError => e
        puts e.message.colorize(:red)
      end
    end
  end
end
