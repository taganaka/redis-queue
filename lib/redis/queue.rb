class Redis
  # :nodoc:
  class Queue
    def self.version
      "redis-queue version #{VERSION}"
    end

    def initialize(redis: Redis.current, timeout: 0)
      @redis = redis
      @timeout = timeout
      @last_message = nil
    end

    def length
      redis.llen waiting
    end

    def clear(clear_process_queue = false)
      redis.del waiting
      redis.del processing if clear_process_queue
    end

    def empty?
      !(length > 0)
    end

    def push(obj)
      serialized_object = Marshal.dump(obj)
      redis.lpush(waiting, serialized_object)
    end

    def pop(non_block = false)
      serialized_object = non_block ? redis.rpoplpush(waiting, processing) : redis.brpoplpush(waiting, processing, timeout)
      @last_message = serialized_object
      deserialized_object = Marshal.load(@last_message) unless @last_message.nil?
    end

    def commit
      redis.lrem(processing, 0, @last_message)
    end

    def process(non_block = false, timeout = nil, count = nil)
      @timeout = timeout unless timeout.nil?
      yield nil if count && count < 0
      loop do
        break unless count.nil? || count > 0
        message = pop(non_block)
        ret = yield message if block_given?
        commit if ret
        count -= 1 unless count.nil?
        break if message.nil? || (non_block && empty?)
      end
    end

    def refill
      while message = redis.lpop(processing)
        redis.rpush(waiting, message)
      end
      true
    end

    def waiting
      @waiting ||= SecureRandom.uuid
    end

    def processing
      @processing ||= SecureRandom.uuid
    end

    alias :size  :length
    alias :dec   :pop
    alias :shift :pop
    alias :enc   :push
    alias :<<    :push

    private
      attr_accessor :redis, :timeout
  end
end