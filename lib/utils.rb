# frozen_string_literal: true

# Utils allows to facilitate command line usage
class Utils < Thor
  desc 'port', 'Check PID for the current process on the specified port'
  long_desc <<-LONGDESC
    `bruw utils port -p [PORT_NUMBER]` will check if a process is running on the specified port

    `--port` or `-p` argument is required

    You can optionally specify a '--kill' or '-k' parameter to kill the process using the specified port

    > $ bruw utils port -p3000

    > $ bruw utils port -p3000 -k
  LONGDESC
  option :port, required: true, banner: 'Port number to be checked', aliases: '-p', type: :numeric
  option :kill, required: false, banner: 'Kill process running on specified port', aliases: '-k', type: :boolean
  def port
    if get_process_pid(options[:port]).empty?
      puts color_str("No process running on : #{options[:port]}", :green)
      return
    end

    pid = get_process_pid(options[:port]).chomp

    unless options[:kill]
      puts "Process running on #{options[:port].to_s.colorize(:green)} has PID : #{pid.to_s.colorize(:green)}"
      return
    end

    kill_process pid
    puts color_str("Process (pid: #{pid}) killed", :red)
  end

  private

  def get_process_pid(port)
    `lsof -t -i:#{port}`
  end

  def kill_process(pid)
    `kill -9 #{pid}`
  end
end
