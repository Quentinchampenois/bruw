# frozen_string_literal: true

# RspecDatShit allows to run easily modified tests using rspec
class RspecDatShit < Thor
  desc 'version', "Check project's ruby version"
  def version
    return if project_ruby_version.nil?

    puts project_ruby_version
    check_version_warning
  end

  desc 'list', 'List tests files from git status'
  def list
    puts list_test_files
  end

  desc 'exec', 'Exec tests from git status'
  long_desc <<-LONGDESC
    `bruw datshit exec` will execute all modified tests in git status

    You can optionally specify a '--line' or '-l' parameter to specify a unique line to test#{' '}

    > $ bruw datshit exec

    > $ bruw datshit exec --line 12

    > $ bruw datshit exec -l 12
  LONGDESC
  option :line, required: false, banner: 'Specify a test line number', aliases: '-l', type: :numeric
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def exec
    return if check_version_warning.nil?

    @unique_line = options[:line] unless options[:line].nil?

    paths = {}
    list_test_files.split("\n").each do |file_path|
      paths[dir(file_path)] = [] if paths[dir(file_path)].nil?

      paths[dir(file_path)] << ".#{file(file_path)}"
    end

    paths.each do |key, value|
      Dir.chdir "#{top_level}/#{key}" do
        system(command(value))
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def check_version_warning
    return false unless RUBY_VERSION != project_ruby_version

    puts <<~WARNING
      Ruby shell doesn't match project desired version! Please set up accordingly.
      Project version: #{@project_ruby_version}
      Shell: #{RUBY_VERSION}

      If you are using rbenv, you can change your ruby shell version using `rbenv shell #{@project_ruby_version}`
    WARNING
  end

  def project_ruby_version
    if !File.exist?(ruby_version_filename) || File.empty?(ruby_version_filename)
      puts color_str("'#{ruby_version_filename}' file not found in project", :red)
      return
    end

    @project_ruby_version ||= File.open(ruby_version_filename).first.chomp
  end

  def list_test_files
    `git status --porcelain | cut -c4- | grep spec.rb`
  end

  def dir(file_path)
    file_path.split(pattern).first
  end

  def file(file_path)
    file_path.match(pattern)
  end

  def command(value)
    "bundle exec rspec #{value.join(' ')}#{unique_line(value)}"
  end

  def unique_line(value)
    return if @unique_line.nil?
    return '' unless value.length == 1

    ":#{@unique_line}"
  end

  def pattern
    %r{/spec/.+}
  end

  def ruby_version_filename
    '.ruby-version'
  end

  def top_level
    `git rev-parse --show-toplevel`.chomp
  end
end
