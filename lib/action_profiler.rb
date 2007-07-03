##
# Typically, action_profiler will be run from the root of your Rails
# application:
# 
#   $ action_profiler GamesController#index
#   Warmup...
#   Profiling...
#   [ profile output ]
#   $
# 
# If you need to run action_profiler from some other path, the -p command line
# option can be used to specify the location of your Rails application.
# 
#   action_profiler -p ~/Worx/X/CCR GamesController#index
# 
# Parameters can be specified after the controller and action:
# 
#   action_profiler GamesController#index ":id => 1"
# 
# If you need to make sure a page is working correctly you can specify -o.  No
# profiling will occur and the generated page will be printed out instead:
# 
#   $ action_profiler -o GamesController#show ":id => 1"
#   <html>
#   [ lots of HTML output ]
#   $

module ActionProfiler

  ##
  # The version of ActionProfiler you are using.

  VERSION = '1.1.0'

end
