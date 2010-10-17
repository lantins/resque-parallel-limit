require File.dirname(__FILE__) + '/test_helper'

class ParallelLimitTimeoutTest < Test::Unit::TestCase
  # parallel limit/timeout settings.
  def test_parallel_limits
    assert_equal 3, ParallelLimitWithTimeout.parallel_limit, 'parallel_limit should be 3.'
    assert_equal 1, ParallelLimitWithTimeout.parallel_timeout, 'parallel_timeout should be 1 seconds.'
  end
end