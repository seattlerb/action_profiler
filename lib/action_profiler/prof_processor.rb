require 'prof'
require 'rubyprof_ext' # From Rails

Prof.clock_mode = Prof::GETTIMEOFDAY

##
# A ProfiledProcessor that uses Shugo Maeda's Prof profiler.
#
# The Prof profiler requires Ruby 1.8.3 or better and can be found at
# http://shugo.net/archive/ruby-prof/
#
# The Prof profiler is configured to use gettimeofday(2).  There is no way to
# change this setting.

class ActionProfiler::ProfProcessor < ActionProfiler::ProfiledProcessor

  def initialize(*args) # :nodoc:
    super
    @profile_data = nil
  end

  def start_profile # :nodoc:
    Prof.start
  end

  ##
  # Prof returns profile data on Prof.stop, so save it for printing.

  def stop_profile # :nodoc:
    @profile_data = Prof.stop
  end

  def print_profile(io = STDERR) # :nodoc:
    return unless @profile_data
    Prof.print_profile @profile_data, io
  end

end

