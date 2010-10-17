require 'resque/plugins/parallel_limit/lock_strategies'

module Resque
  module Plugins
    # A Resque plugin to impose a parallel processing limit on jobs, based
    # upon their arguments.
    module ParallelLimit
      class ParalleLockFailedError < RuntimeError
      end

      # it all goes down here.
      def around_perform_parallel_limit(*args)
        # using a lock strategy, aquire a lock.
        unless lock = lock_strategy.aquire(*args)
          parallel_lock_failed(*args) if respond_to?(:parallel_lock_failed)
          # silently discard/drop the job, unless you raise an exception.
          return
        end

        begin
          yield # your job runs here.
        ensure
          lock_strategy.release(lock)
        end
      end

      # Returns the lock strategy module.
      def lock_strategy
        parallel_timeout > 0 ? TimeoutLockStrategy : IncrDecrLockStrategy
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

      # Hook method: called when unable to aquire lock.
      def parallel_lock_failed(*args)
        raise ParalleLockFailedError, 'unable to aquire a parallel lock.'
      end

      def log(msg)
        puts msg
      end

    end
  end
end