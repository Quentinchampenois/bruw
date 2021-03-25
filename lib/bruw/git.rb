# frozen_string_literal: true

module Bruw
  class Git
    def self.remotes(pattern = "")
      return `git remote` if pattern.empty?

      `git remote | grep ^#{pattern}`.split
    end

    def self.branch(remote, branch)
      `git branch -D #{branch} && git checkout #{remote}/#{branch} && git switch -c #{branch}`
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

    def self.git?
      Dir.exist?(".git")
    end
  end
end
