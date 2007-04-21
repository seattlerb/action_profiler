require 'rubygems'
require 'action_controller'

require 'action_profiler/path2class'

# :stopdoc:

# This exists because Rails coupled test processing to unit testing.

# Don't load assertions or deprecated assertions by faking entries in $".
gs = Gem::GemPathSearcher.new
path = gs.find('action_controller/test_process').full_gem_path
$" << File.join(path, 'lib', 'action_controller', 'assertions.rb')
$" << File.join(path, 'lib', 'action_controller', 'deprecated_assertions.rb')

# This lameness exists because Rails injects into Test::Unit::TestCase when
# it should use subclasses.

module Test; end
module Test::Unit; end
class Test::Unit::TestCase; end

# :startdoc:

require 'action_controller/test_process'

##
# TestProcessor is a class that exercises a Rails controller action.
#
# TestProcessor is heavily based on ActionPack's
# lib/action_controller/test_process.rb
#
# The original can be found at: http://dev.rubyonrails.org/browser/trunk/actionpack/lib/action_controller/test_process.rb
#
# The methods #process and #build_request_uri are copyright (c) 2004 David
# Heinemeier Hansson and are used under the MIT License.  All original code is
# subject to the LICENSE file included with Action Profiler.
#--
# Per the MIT license:
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class ActionProfiler::TestProcessor

  ##
  # Creates a new TestProcessor that will profile +action+ with +method+.
  # +params+, +session+ and +flash+ are hashes for use in processing the
  # request.
  #
  # +action+ is a String with the format "GamesController#index".
  #
  # +method+ is one of the HTTP request methods, get, post, etc.

  def initialize(action, method, params = nil, session = nil, flash = nil)
    unless action =~ /^([:\w]+Controller)#(\w+)$/ then
      raise ArgumentError, "invalid action name" 
    end

    @controller_name = $1
    @action_name = $2
    @method = method.downcase

    @params = params
    @session = session
    @flash = flash

    begin
      controller_klass = Object.path2class @controller_name
    rescue NameError
      raise ArgumentError, "can't find controller #{@controller_name}"
    end

    @controller = controller_klass.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries = []
  end

  ##
  # Runs this action.

  def process
    @request.recycle!

    @html_document = nil # Why? Who knows!
    @request.env['REQUEST_METHOD'] = @method
    @request.action = @action_name

    @request.assign_parameters(@controller.class.controller_path, @action_name,
                               @params)

    @request.session = ActionController::TestSession.new @session
    @request.session['flash'] = ActionController::Flash::FlashHash.new
    @request.session['flash'].update @flash

    build_request_uri
    @controller.process @request, @response
  end

  private

  def build_request_uri
    return if @request.env['REQUEST_URI']
    options = @controller.send :rewrite_options, @params
    options.update :only_path => true, :action => @action_name

    url = ActionController::UrlRewriter.new @request, @params
    @request.set_REQUEST_URI url.rewrite(options)
  end

end

