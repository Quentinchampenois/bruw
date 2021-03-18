# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'fileutils'

# Decidim allows to easily Decidim local applications
class Decidim < Thor
  desc 'version', 'Print the current Decidim’s version'
  long_desc <<-LONGDESC
    `bruw dcd version` checks the Decidim's version for the current project 

    > $ bruw dcd version
  LONGDESC
  def version
    unless File.exist?('Gemfile.lock')
      puts color_str('No file Gemfile.lock found', :red)
      return
    end

    puts read_gemfile_lock
  end

  desc 'curl', 'curl specific file'
  long_desc <<-LONGDESC
    `bruw dcd curl` allows to curl source code of specified path for a given version 

    > $ bruw dcd version
  LONGDESC
  option :path, required: false, banner: 'Full relative path from decidim root', aliases: '-p', type: :string
  option :tag, required: false, banner: 'Tag has to have format vx.xx.x : Default current decidim version', aliases: '-t', type: :string
  option :owner, required: false, banner: 'Owner name : Default \'decidim\'', aliases: '-o', type: :string
  option :repo, required: false, banner: 'Repository name : Default \'decidim\'', aliases: '-r', type: :string
  option :silent, required: false, banner: 'Disable request output', aliases: '-s', type: :boolean
  option :save, required: false, banner: 'Save output in relative path', aliases: '-s', type: :boolean
  def curl(path)

    options[:tag] = "v#{options[:tag]}" if options[:tag][0] != 'v'
    url = "#{raw_github_based(options[:owner], options[:repo], options[:tag])}/#{path}"
    uri = URI.parse(url)

    if Net::HTTP.get_response(uri).is_a?(Net::HTTPNotFound)
      puts color_str("Path not found ! \nurl : #{url}", :red)
      return
    elsif Net::HTTP.get_response(uri).is_a? Net::HTTPOK
      response = Net::HTTP.get uri

      if options[:save]
        path = strip_path(path)
        create_path(path)
        save_file(path, response.chop)

        puts color_str("File '#{path}' overwrite", :green)
      else
        puts response
      end
    end
  end

  private

  def read_gemfile_lock
    lines = File.open('Gemfile.lock')
    decidim_version = ''
    lines.each do |line|
      next unless /decidim \((?!=).+/i =~ line

      idx = line.strip.chars.index('(')

      decidim_version = line.strip[idx+1..line.strip.size-2] unless idx.nil?
    end

    decidim_version
  end

  def save_file(path, content)
    File.open(path, 'w') do |f|
      f.puts content
    end

    puts color_str("File '#{path}' created.", :green)
  end

  def create_path(path)
    return if Dir.exist?(path)

    FileUtils.mkpath(File.dirname(path))
  end

  def strip_path(path)
    return path unless decidim_app?

    path.split('/')[1..].join('/')
  end

  def decidim_app?
    !Dir.exist?('decidim-core') || !Dir.exist?('decidim-admin') || !Dir.exist?('decidim-initiatives')
  end

  def raw_github_based(owner, repo, version)
    owner = 'decidim' if owner.nil? || owner.empty?
    repo = 'decidim' if repo.nil? || repo.empty?
    version = "v#{read_gemfile_lock}" if version.nil? || version.empty?

    "https://raw.githubusercontent.com/#{owner}/#{repo}/#{version}"
  end
end
