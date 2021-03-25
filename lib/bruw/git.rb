# frozen_string_literal: true

module Bruw
  class Git
    # Returns a list of repos that match specified patterns pattern
    def self.repos(owner, pattern = "", without = "")
      cmd = "gh repo list #{owner}"
      cmd = "#{cmd} | grep #{pattern}" unless pattern.nil? || pattern.empty?
      cmd = "#{cmd} | grep -v #{without}" unless without.nil? || without.empty?

      repos = `#{cmd}`.gsub!(/\s+/, " ").split

      repos = repos.select do |repo|
        repo.start_with?(owner)
      end

      repos.map do |repo|
        repo.split("/")[1]
      end
    end

    def self.remotes(pattern = "")
      return `git remote` if pattern.empty?

      `git remote | grep ^#{pattern}`.split
    end

    def self.branch(remote, branch)
      `git branch -D #{branch}` if branch_exists?(branch)
      `git checkout #{remote}/#{branch} && git switch -c #{branch}`
    end

    def self.fetch(remote)
      `git fetch #{remote}`
    end

    def self.prune_remotes(remotes)
      raise StandardError, "An error occured, please check git remotes" if remotes.nil? || !remotes.respond_to?(:each)
      raise StandardError, "No git remotes to prune" if remotes.empty?

      remotes.each do |remote|
        puts "Removing #{remote.colorize(:green)}..."
        `git remote remove #{remote}`
      end
    end

    def self.cmd_exists?(cmd)
      !`which #{cmd}`.empty?
    end

    def self.git?
      Dir.exist?(".git")
    end

    def self.branch_exists?(branch)
      !`git branch --list #{branch}`.empty?
    end

    def self.local_changes?
      !`git status`.match(/Changes not staged for commit:/).nil?
    end
  end
end
