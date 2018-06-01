# frozen_string_literal: true

require 'redis-queue'

redis = Redis.new

queue = Redis::Queue.new('__test', 'bp__test', redis: redis)
queue.clear true

100.times { queue << rand(100) }

queue.process(true) { |m| puts m }
