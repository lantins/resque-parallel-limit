module Resque
  module Plugins
    module ParallelLimit

      module IncrDecrLockStrategy
        def acquire(*args)
          # size < parallel_limit: incr count.
          # size >= parallel_limit: bail out.
        end

        def release(lock)
          # decr count or delete if 1.
        end
      end

      module TimeoutLockStrategy
        def acquire(*args)
          # grab a list of timestamps from redis.
          # list length >= parallel_limit: check if timestamp has expired?
            # if one has expired, replace it with our timestamp.
          # list length < parallel_limit: add our timestamp to the list.
        end

        def release(lock)
          # check if our lock as expired?
            # lock expired before perform complete, fire callback.
          # not expired, remove our timestamp from the list.
        end
      end

    end
  end
end