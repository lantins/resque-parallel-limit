module Resque
  module Plugins
    # A Resque plugin to impose a parallel processing limit on jobs, based
    # upon their arguments.
    module ParallelLimit
      class ParalleLockFailedError < RuntimeError
      end

      # it all goes down here.
      def around_perform_parallel_limit(*args)
        # using a lock strategy, acquire a lock.
        key = parallel_limit_key(*args)
        unless acquire_parallel_lock(key)
          parallel_lock_failed(*args) if respond_to?(:parallel_lock_failed)
          # silently discard/drop the job, unless you raise an exception.
          return
        end

        begin
          yield # your job runs here.
        ensure
          release_parallel_lock(key)
        end
      end

      def acquire_parallel_lock(key)
        now = Time.now.to_f
        lock = now + parallel_timeout
        acquired = false

        # have we hit the limit?
        if Resque.redis.llen(key) >= parallel_limit_key
          # oh noes, limit hit!
          # look at the oldest timestamp.
          lock_expire = Resque.redis.lrange(key, -1, -1).last # last element of the list.

          return nil unless lock_expire && lock_expire.to_i < now
          # lock has expired!
          Resque.redis.rpop(key) # remove last element.
        end
        # we've not hit the limit!
        Resque.redis.lpush(key, lock) # add our lock to the start.
      end

      def release_parallel_lock(key)
        Resque.redis.rpop(key) # remove last element.
      end

      def parallel_timeout
        @parallel_timeout ||= 0
      end

      # Max number of parallel jobs for our `parallel_limit_key`.
      def parallel_limit
        @parallel_limit ||= 0
      end

      # customise your parallel limit key as required.
      def parallel_limit_key(*args)
        "parallel-limit:#{args[0]}"
      end

      # Hook method: called when unable to acquire lock.
      def parallel_lock_failed(*args)
        raise ParalleLockFailedError, 'unable to acquire a parallel lock.'
      end

      def log(msg)
        puts msg
      end

    end
  end
end