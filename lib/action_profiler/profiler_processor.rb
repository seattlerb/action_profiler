require 'profiler'

##
# A ProfiledProcessor that uses Ruby's built-in Profiler__ class.
#
# ProfilerProcessor is very slow.  You really want to upgrade to Ruby 1.8.3 or
# better and use ZenProfilerProcessor or ProfProcessor.

class ActionProfiler::ProfilerProcessor < ActionProfiler::ProfiledProcessor

  def start_profile # :nodoc:
    Profiler__.start_profile
  end

  def stop_profile # :nodoc:
    Profiler__.stop_profile
  end

  def print_profile(io = STDERR) # :nodoc:
    Profiler__.print_profile io
  end

end

