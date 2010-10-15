module Resque
  module Plugins

    # A Resque plugin to impose a parallel processing limit on jobs, based
    # upon their arguments.
    module ParallelLimit
      class Error < StandardError
      end

      class LockFailedError < Error
      end

      # it all goes down here.
      def around_perform_parallel_limit(*args)
        unless lock = acquire_parallel_lock(*args)
          parallel_lock_failed(*args) if respond_to?(:parallel_lock_failed)

          # if parallel_lock_failed doesn't raise an exception, silently
          # discard the job.
          return
        end

        begin
          yield
        ensure
          release_parallel_lock(lock)
        end
      end

      # acquire a parallel lock if one is available.
      def acquire_parallel_lock(*args)
        log "acquire lock."
        key = parallel_limit_key(*args)
        log "redis key: #{key}"

        # grab a list of timestamps from redis.
        # list length >= parallel_limit: check if timestamp has expired?
          # if one has expired, replace it with our timestamp.
        # list length < parallel_limit: add our timestamp to the list.
      end

      # release a parallel lock.
      def release_parallel_lock(*args)
        log "release lock."

        # make sure the lock timestamp were about to remove has not expired.
      end

      # hook method if we couldn't aquire a lock.
      def parallel_lock_failed(*args)
        raise LockFailedError, 'unable to aquire a parallel lock.'
      end

      def parallel_timeout
        @parallel_timeout ||= 0
      end

      def parallel_limit
        @parallel_limit ||= 0
      end

      # customise your parallel limit key as required.
      def parallel_limit_key(*args)
        "parallel-limit:#{args[0]}"
      end

      def log(msg)
        puts msg
      end
    end

  end
end