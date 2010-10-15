**n.b.** This is *alpha* software!

resque-parallel-limit
=====================

resque-parallel-limit is a [Resque][re] plugin that allows you to impose a
parallel processing limit on multiple jobs, based on their arguments.

Install & Quick Start
---------------------

Extended Example
----------------

In this example our jobs perform several network related tasks such as pinging
or sending data.

Every job requires the first argument to be `ip_address`.

A maximum of 4 jobs may run in parallel for the same ip_address.

    # setup in a module so we can impose the limit across multiple jobs.
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

[re]: http://github.com/defunkt/resque
