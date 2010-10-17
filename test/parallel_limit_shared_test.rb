require File.dirname(__FILE__) + '/test_helper'

class ParallelLimitSharedTest < Test::Unit::TestCase
  # parallel limit setting.
  def test_parallel_limit_setting
    assert_equal 4, SendDataJob.parallel_limit, 'SendDataJob.parallel_limit should be 2.'
    assert_equal 4, PingJob.parallel_limit, 'PingJob.parallel_limit should be 2.'
  end

  # parallel timeout setting.
  def test_parallel_timeout_setting
    assert_equal 600, SendDataJob.parallel_timeout, 'SendDataJob.parallel_timeout should be 600 seconds.'
    assert_equal 600, PingJob.parallel_timeout, 'PingJob.parallel_timeout should be 600 seconds.'
  end
end