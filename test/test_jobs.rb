module IPAddrParallelLimit
  include Resque::Plugins::ParallelLimit

  parallel_limit 4
  parallel_timeout 600

  # our first arg will always be the 
  def resque_parallel_limit_key(*args)
    "parallel-limit:ipaddr:#{args[0]}"
  end
end

module SendDataJob
  extend IPAddrParallelLimit

  def self.perform(ip_address, data)
  end
end

module PingJob
  extend IPAddrParallelLimit

  def self.perform(ip_address)
  end
end