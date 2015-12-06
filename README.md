redis-queue
=============
Requires the redis gem.

Adds Redis::Queue class which can be used as Distributed-Queue based on Redis.
Redis is often used as a messaging server to implement processing of background jobs or other kinds of messaging tasks.
It implements Reliable-queue pattern decribed here: http://redis.io/commands/rpoplpush.

Installation
----------------
    $ gem install redis-queue

Testing
----------------
    $ bundle install
    $ rake

Simple usage
----------------

```ruby
require "redis-queue"
redis = Redis.new
queue = Redis::Queue.new(redis: redis)

#Adding some elements
queue.push "b" 
queue << "a" # << is an alias of push

# Process messages

# By default, calling pop method is a blocking operation
# Your code will wait here for a new  
while message=@queue.pop
  #Remove message from the backup queue if the message has been processed without errors
  queue.commit if YourTask.new(message).perform.succeed?
end

#Process messages using block

@queue.process do |message|
  #@queue.commit is called if last statement of the block returns true
  YourTask.new(message).perform.succeed?
end

# Process messages with timeout (starting from version 0.0.3)
# Wait for 15 seconds for new messages, then exit
queue.process(false, 15) do |message|
  puts "'#{message}'" 
end

# Process messages in a non blocking-way
# A soon as the queue is empty, the block will exit
queue.process(true) do |message|
  puts "'#{message}'" 
end
```
Contributing to redis-queue
----------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
----------------

Copyright (c) 2013 Francesco Laurita. See LICENSE.txt for
further details.

