# frozen_string_literal: true

require 'colorize'

RUBY_VERSION_FILENAME = '.ruby-version'

# RspecDatShit allows to run easily modified tests using rspec
class RspecDatShit < Thor
  desc 'version', "Check project's ruby version"
  def version
    return if project_ruby_version.nil?

    puts project_ruby_version

    return unless RUBY_VERSION != @project_ruby_version

    puts <<~WARNING
      Ruby shell doesn't match project desired version! Please set up accordingly.
      Project version: #{@project_ruby_version}
      Shell: #{RUBY_VERSION}
    WARNING
  end

  private

  def project_ruby_version
    if !File.exist?(RUBY_VERSION_FILENAME) || File.empty?(RUBY_VERSION_FILENAME)
      puts color_str("'#{RUBY_VERSION_FILENAME}' file not found in project", :red)
      return
    end

    @project_ruby_version ||= File.open(RUBY_VERSION_FILENAME).first.chomp
  end

  def color_str(str, color)
    str.colorize(color)
  end
end
