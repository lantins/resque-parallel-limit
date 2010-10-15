dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'
$TESTING = true

require 'test/unit'
require 'rubygems'
require 'simplecov'
require 'rr'

SimpleCov.start do
  add_filter "/test/"
end

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

# require our failure backend to test.
require 'resque-parallel-limit'

# adds simple STDOUT logging to test workers.
# set `VERBOSE=true` when running the tests to view resques log output.
module Resque
  class Worker
    def log(msg)
      puts "*** #{msg}" unless ENV['VERBOSE'].nil?
    end
    alias_method :log!, :log
  end
end