require "redis-queue"
require "thread"

redis = Redis.new
#Create a queue that will listen for a new element for 10 seconds
queue = Redis::Queue.new('__test', 'bp__test', :redis => redis, :timeout => 10)
queue.clear true 

100.times { queue << rand(100) }

# Simulate a delayed insert
t = Thread.new do
  sleep 3
   # We should use a second connection here since the first one is busy 
   # on a blocking call
  _redis = Redis.new
  _queue = Redis::Queue.new('__test', 'bp__test', :redis => _redis)
  100.times { _queue << "e_#{rand(100)}" }
end

#When all elements are dequeud, process method will wait for 10 secods before exit
queue.process do |message|
  puts "'#{message}'" 
end
t.join