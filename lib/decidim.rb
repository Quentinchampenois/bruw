# frozen_string_literal: true

# Decidim allows to easily Decidim local applications
class Decidim < Thor
  desc 'version', 'Print the current Decidim’s version'
  long_desc <<-LONGDESC
    `bruw dcd version` checks the Decidim's version for the current project 

    > $ bruw dcd version
  LONGDESC
  def version
    unless File.exist?("Gemfile.lock")
      puts color_str("No file Gemfile.lock found", :red)
      return
    end

    puts read_gemfile_lock
  end

  private

  def read_gemfile_lock
    lines = File.open("Gemfile.lock")
    decidim_version = ''
    lines.each do |line|
      next unless /decidim \((?!=).+/i =~ line

      idx = line.strip.chars.index('(')

      decidim_version = line.strip[idx+1..line.strip.size-2] unless idx.nil?
    end

    decidim_version
  end
end
