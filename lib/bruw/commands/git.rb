# frozen_string_literal: true

require "thor"

module Bruw
  module Commands
    class Git < Thor
      desc "open REMOTE", "Open current repository in browser"
      long_desc <<-LONGDESC
        Open current repository in browser

 Default remote is Origin
      LONGDESC
      def open(remote = "origin")
        raise StandardError, "Not in git repository" unless Bruw::Git.git?

        remote = Bruw::Git.remotes(remote)
        path = Bruw::Git.find_path(remote)

        current_branch = `git branch --show-current`
        `open https://github.com/#{path}/tree/#{current_branch}`
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "remotes", "Get all current git remotes"
      long_desc <<-LONGDESC
        Get all current git remotes
      LONGDESC
      def remotes
        puts Bruw::Git.remotes
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "add-remotes", "Add several remote at once"
      long_desc <<-LONGDESC
        Add several remote at once
      LONGDESC
      option :pattern, required: false, banner: "Specify repo name pattern to match", aliases: "-p", type: :string
      option :without, required: false, banner: "Specify repo name pattern that must not match", aliases: "-w", type: :string
      option :all, required: false, banner: "Disable selection and add all repos", aliases: "-a", type: :boolean, default: false
      def add_remotes(owner = "OpenSourcePolitics")
        unless Bruw::Git.cmd_exists?("gh")
          raise StandardError, "Please install Github CLI for using this command

You can install it using brew

`brew install gh` or upgrade `brew upgrade gh`

This command needs at least v1.7.0 for command repo list (https://github.com/cli/cli/releases/tag/v1.7.0)
Official repository : https://github.com/cli/cli"
        end
        prompt = TTY::Prompt.new

        remotes = Bruw::Git.repos(owner, options[:pattern], options[:without])

        remotes = prompt.multi_select("Select the git remote you want to add", remotes) unless options[:all]

        remotes.each do |remote|
          `git remote add #{remote} git@github.com:#{owner}/#{remote}.git`
        end
      rescue StandardError => e
        puts e.message.colorize(:red)
      end

      desc "branch REMOTE BRANCH", "Create branch and removes existing one"
      long_desc <<-LONGDESC
        This command allows to create locally the specified git branch for the given remote

        It fetch the git remote and then DESTROY the existing branch
      LONGDESC
      def branch(remote, branch)
        raise StandardError, "You have uncommitted work, please commit or stash work before" if Bruw::Git.local_changes?
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
