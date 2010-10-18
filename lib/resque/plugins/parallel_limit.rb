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
        unless lock = acquire_parallel_lock(key)
          parallel_lock_failed(*args) if respond_to?(:parallel_lock_failed)
          # silently discard/drop the job, unless you raise an exception.
          return
        end

        begin
          yield # your job runs here.
        ensure
          release_parallel_lock(key, lock)
        end
      end

      def acquire_parallel_lock(key)
        now = Time.now.to_f
        lock = now + parallel_timeout
        acquired = false

        # have we hit the limit?
        if Resque.redis.zcard(key) >= parallel_limit
          # oh noes, limit hit! try to remove an old lock.
          return nil unless Resque.redis.zremrangebyscore(key, 0, now)
        end
        # try and acquire!
        Resque.redis.zadd(key, lock, worker_lock_member)
      end

      def release_parallel_lock(key, lock)
        # FIXME: add better checks:
        #   - has the timeout already passed?
        #   - did someone else remove our lock?
        Resque.redis.zrem(key, lock)
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

      def worker_lock_member
        "#{hostname}:#{Process.pid}"
      end

      def hostname
        @hostname ||= `hostname`.chomp
      end

    end
  end
end