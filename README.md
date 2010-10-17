**n.b.** This is *alpha* software, and not working yet!

resque-parallel-limit
=====================

resque-parallel-limit is a [Resque][re] plugin that allows you to impose a
parallel processing limit on multiple jobs, based on their arguments.

Install & Quick Start
---------------------

To install:

    $ gem install resque-parallel-limit

Use the plugin:

    require 'resque-parallel-limit'

    module WebHookDelivery
      extend Resque::Plugins::ParallelLimit

      @parallel_limit = 6
      @parallel_timeout = 300

      def self.perform(url, json)
        # heavy lifting.
      end
    end

Parallel Lock Strategies
------------------------

### Incr/Decr Strategy

### Timeout Strategy

Callbacks
---------

Several callback methods are available for you to override:

### `parallel_lock_failed`

Sharing Limits With Multiple Job Modules/Classes
------------------------------------------------

In this example our jobs perform several network related tasks such as pinging
or sending data.

  * Each job expects `ip_address` as the first argument.
  * A maximum of 4 jobs may run in parallel for the same ip_address.

### Code

    # setup in a module so we can impose the limit across multiple jobs.
    module IPAddrParallelLimit
      include Resque::Plugins::ParallelLimit

      def parallel_limit
        4
      end

      def parallel_timeout
        600
      end

      # our first arg will always be the 
      def resque_parallel_limit_key(*args)
        "parallel-limit:ipaddr:#{args[0]}"
      end
    end

    module SendDataJob
      extend IPAddrParallelLimit
      @queue = :send_data

      def self.perform(ip_address, data)
      end
    end

    module PingJob
      extend IPAddrParallelLimit
      @queue = :ping_ip

      def self.perform(ip_address)
      end
    end

[re]: http://github.com/defunkt/resque
