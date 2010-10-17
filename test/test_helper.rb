# modify our load path, work with the local version.
dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir
$LOAD_PATH.unshift dir + '/../lib'
$TESTING = true

require 'redis_bootstrap'

# code coverage from here on our please.
require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

require 'test/unit'
require 'rr'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

require 'resque-parallel-limit'
require 'test_jobs'

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

Resque.redis = Redis.new(:host => '127.0.0.1', :port => 9736, :db => 1)