# frozen_string_literal: true

require 'redis-queue'
redis = Redis.new
# Create a queue that will listen for a new element for 10 seconds
queue = Redis::Queue.new('__test', 'bp__test', redis: redis, timeout: 10)
queue.clear true

100.times { queue << rand(100) }

# Simulate a delayed insert
t = Thread.new do
  sleep 3
  # We should use a second connection here since the first one is busy
  # on a blocking call
  other_redis = Redis.new
  other_queue = Redis::Queue.new('__test', 'bp__test', redis: other_redis)
  100.times { other_queue << "e_#{rand(100)}" }
end

# When all elements are dequeud, process method will wait for 10 secods before exit
queue.process do |message|
  puts "'#{message}'"
end
t.join
