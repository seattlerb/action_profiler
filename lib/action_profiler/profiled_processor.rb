require 'optparse'

require 'config/environment'
require 'action_profiler/test_processor'

# HACK remove

def debug(msg)
  $stderr.puts msg if $AP_DEBUG
end

##
# A Rails action processor that profiles an entire action.
#
# ProfiledProcessor is an abstract class.  A subclasses must implement
# #start_profile, #stop_profile and #print_profile.

class ActionProfiler::ProfiledProcessor < ActionProfiler::TestProcessor

  PROFILERS = ['ZenProfiler', 'Prof', 'Profiler']

  ##
  # Processes +args+ then runs a profile based on the arguments given.

  def self.process_args(args = ARGV)
    app_path = Dir.pwd
    method = 'GET'
    only_html = false
    processor_klass = nil
    times = 1

    opts = OptionParser.new do |opts|
      opts.version = ActionProfiler::VERSION
      opts.banner = "Usage: #{File.basename $0} [options] method [params [session [flash]]]"

      opts.separator ''
      opts.separator 'method: controller and action to run "GamesController#index"'
      opts.separator 'params, session, flash: Hash-style arguments ":id => 5"'
      opts.separator ''

      opts.on("-m", "--method=HTTP_METHOD",
              "HTTP request method for this action",
              "Default: #{method}") do |val|
        method = val
      end

      opts.on("-o", "--[no-]only-html",
              "Only output rendered page",
              "Default: #{only_html}") do |val|
        only_html = val
      end

      opts.on("-p", "--app-path=PATH",
              "Path to Rails application root",
              "Default: current directory") do |val|
        unless File.directory? val then
          raise OptionParser::InvalidArgument, "bad path: #{val}"
        end

        app_path = val
      end

      opts.on("-P", "--profiler=PROFILER",
              "Profiler to use",
              "Default: ZenProfiler, Prof then Profiler") do |val|
        begin
          processor_klass = load_processor val
        rescue LoadError
          raise OptionParser::InvalidArgument, "can't load #{val}Processor"
        end
      end

      opts.on("-t", "--times=TIMES", Integer,
              "Times to run the action under the profiler",
              "Default: #{times}") do |val|
        times = val
      end

      opts.separator ''
      opts.on("-h", "--help", "Display this help") { STDERR.puts opts; exit 1 }
      opts.on("-d", "--debug", "Enable debugging output") do |val|
        $AP_DEBUG = val
      end
      opts.separator ''

      opts.parse! args
    end

    processor_klass = load_default_processor if processor_klass.nil?

    begin
      Dir.chdir app_path
      require 'config/environment'
    rescue LoadError => e
      debug "Application load error \"#{e.message}\""
      raise OptionParser::InvalidArgument, "could not load application, check your path"
    end

    raise OptionParser::ParseError, "action not specified" if args.empty?
    action = args.shift

    raise OptionParser::ParseError, "too many arguments" if args.length > 3

    begin
      params, session, flash = args.map { |arg| eval "{#{arg}}" }
    rescue Exception
      raise OptionParser::ParseError, "invalid param/session/flash argument"
    end

    params ||= {}
    session ||= {}
    flash ||= {}

    debug "Using #{processor_klass.inspect} processor"

    pp = processor_klass.new action, method, params, session, flash, only_html
    pp.profile times

  rescue ArgumentError, OptionParser::ParseError => e
    STDERR.puts e.message
    debug "\t#{$!.backtrace.join("\n\t")}"
    STDERR.puts
    STDERR.puts opts.to_s
    exit 1
  end

  ##
  # Attempts to load the default profilers in order.  Returns the first
  # successfully found profiler class.

  def self.load_default_processor
    PROFILERS.each do |profiler|
      begin
        return load_processor(profiler)
      rescue LoadError => e
      end
    end
    raise "couldn't load any profilers, how strange, sorry about that"
  end

  ##
  # Attempts to load a processor starting with +name+.  Returns the loaded
  # class if successful.

  def self.load_processor(name)
    debug "Loading #{name}Processor"
    require "action_profiler/#{name.downcase}_processor"
    return ActionProfiler.path2class("#{name}Processor")
  rescue LoadError => e
    debug "Failed to load #{name}Processor: #{e.message}"
    raise
  end

  ##
  # If +only_html+ is true then only the rendered page will be displayed and
  # no profiling will be performed.  See TestProcessor#new for the rest.

  def initialize(action, method, params, session, flash, only_html)
    super action, method, params, session, flash
    @only_html = only_html
  end

  ##
  # Profiles the action, running it under the profiler +times+ times after
  # three warmup actions.

  def profile(times = 1)
    if @only_html then
      process
      puts @response.body
      return
    end

    STDERR.puts "Warmup..."
    3.times { process }

    begin
      STDERR.puts "Profiling..."
      start_profile
      times.times { process }
      stop_profile
    ensure
      print_profile
    end
  end

  ##
  # Implemented by a subclass to start the profiler it uses.

  def start_profile
    raise NotImplementedError
  end

  ##
  # Implemented by a subclass to stop the profiler it uses.

  def stop_profile
    raise NotImplementedError
  end

  ##
  # Implemented by a subclass to print out the profile data to +io+.

  def print_profile(io)
    raise NotImplementedError
  end

end

