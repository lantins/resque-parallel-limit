module SimpleParallelLimit
  extend Resque::Plugins::ParallelLimit

  @parallel_limit = 2

  def self.perform(*args)
    log "#{self} - limit: #{parallel_limit}, timeout: #{parallel_timeout}"
  end
end

module ParallelLimitWithTimeout
  extend Resque::Plugins::ParallelLimit

  @parallel_limit = 3
  @parallel_timeout = 1

  def self.perform(*args)
    log "#{self} - limit: #{parallel_limit}, timeout: #{parallel_timeout}"
  end
end



# Example: share a parallel limit between multiple modules/classes:
module IPAddrSharedParallelLimit
  include Resque::Plugins::ParallelLimit

  # this is verbose... but it does work.
  def parallel_limit
    4
  end

  def parallel_timeout
    600
  end

  # here our parallel limit is by IP Address (1st argument).
  def parallel_limit_key(*args)
    "parallel-limit:ipaddr:#{args[0]}"
  end
end

module SendDataJob
  extend IPAddrSharedParallelLimit

  def self.perform(ip_address, data)
    log "#{self} - limit: #{parallel_limit}, timeout: #{parallel_timeout}"
  end
end

class PingJob
  extend IPAddrSharedParallelLimit

  def self.perform(ip_address)
    log "#{self} - limit: #{parallel_limit}, timeout: #{parallel_timeout}"
  end
end