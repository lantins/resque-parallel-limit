require File.dirname(__FILE__) + '/test_helper'

class ParallelLimitTest < Test::Unit::TestCase
  # parallel limit setting.
  def test_parallel_limit_setting
    assert_equal 2, SimpleParallelLimit.parallel_limit, 'parallel_limit should be 2.'
  end

  # parallel timeout setting default.
  def test_parallel_timeout_setting
    assert_equal 0, SimpleParallelLimit.parallel_timeout, 'parallel_timeout should be the default 0.'
  end
end