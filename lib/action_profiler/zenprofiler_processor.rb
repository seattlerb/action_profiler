require 'zenprofile'

##
# A ProfiledProcessor that uses Ryan Davis' ZenProfiler.
#
# The ZenProfiler profiler requires Ruby 1.8.3 or better and RubyInline.
# ZenProfiler can be found at http://rubyforge.org/frs/?group_id=712

class ActionProfiler::ZenProfilerProcessor < ActionProfiler::ProfiledProcessor

  def start_profile # :nodoc:
    ZenProfiler.start_profile
  end

  def stop_profile # :nodoc:
    ZenProfiler.stop_profile
  end

  def print_profile(io = STDERR) # :nodoc:
    ZenProfiler.print_profile io
  end

end

