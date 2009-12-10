= Action Profiler

* http://seattlerb.rubyforge.org/action_profiler
* {action_profiler Bug Tracker}[http://rubyforge.org/tracker/?func=add&group_id=1513&atid=5921]

== DESCRIPTION:

action_profiler allows you to profile a single Rails action to determine what
to optimize.  You can use the Production Log Analyzer and action_grep to
determine which actions you should profile and what arguments to use.

Information on the Production Log Analyzer can be found at:

http://rails-analyzer.rubyforge.org/pl_analyze

=== Profilers

Action Profiler REQUIRES Ruby 1.8.3 or newer, even if you just use
Ruby's builtin profiler.

Action Profiler can use three profilers, ZenProfile, Ruby's builtin
profiler class or Shugo Maeda's Prof.

Shugo Maeda's Prof: http://raa.ruby-lang.org/project/ruby-prof

ZenProfile: http://rubyforge.org/frs/?group_id=712&release_id=2476

=== Running Action Profiler

See ActionProfiler

== LICENSE:

Portions copyright 2004 David Heinemeier Hansson.

All original code copyright 2005, 2007 Eric Hodel, The Robot Co-op.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the names of the authors nor the names of their contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

