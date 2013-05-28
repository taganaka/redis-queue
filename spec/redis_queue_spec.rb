require 'spec_helper'

describe Redis::Queue do
  before(:all) do
    @redis = Redis.new
    @queue = Redis::Queue.new('__test', 'bp__test')
    @queue.clear true 
  end

  after(:all) do
    @queue.clear true
  end

  it 'should return correct version string' do
    Redis::Queue.version.should == "redis-queue version #{Redis::Queue::VERSION}"
  end

  it 'should create a new redis-queue object' do
    queue = Redis::Queue.new('__test', 'bp__test')
    queue.class.should == Redis::Queue
  end

  it 'should add an element to the queue' do
    @queue << "a"
    @queue.size.should be == 1
  end

  it 'should return an element from the queue' do
    message = @queue.pop(true)
    message.should be == "a"
  end

  it 'should remove the element from bp_queue if commit is called' do 
    @redis.llen('bp__test').should be == 1
    @queue.commit
    @redis.llen('bp__test').should be == 0
  end

  it 'should implements fifo pattern' do
    @queue.clear
    payload = %w(a b c d e)
    payload.each {|e| @queue << e}
    test = []
    while e=@queue.pop(true)
      test << e
    end
    payload.should be == test
  end

  it 'should remove all of the elements from the main queue' do
    %w(a b c d e).each {|e| @queue << e}
    @queue.size.should be > 0
    @queue.pop(true)
    @queue.clear
    @redis.llen('bp__test').should be > 0
  end

  it 'should reset queues content' do
    @queue.clear(true)
    @redis.llen('bp__test').should be == 0
  end

  it 'should prcess a message' do
    @queue << "a"
    @queue.process(true){|m|m.should be == "a"; true}
  end

  it 'should prcess a message leaving it into the bp_queue' do
    @queue << "a"
    @queue << "a"
    @queue.process(true){|m|m.should be == "a"; false}
    @redis.lrange('bp__test',0, -1).should be == ['a', 'a']
  end

  it 'should refill a main queue' do
    @queue.clear(true)
    @queue << "a"
    @queue << "a"
    @queue.process(true){|m|m.should be == "a"; false}
    @redis.lrange('bp__test',0, -1).should be == ['a', 'a']
    @queue.refill
    @redis.lrange('__test',0, -1).should be == ['a', 'a']
    @redis.llen('bp__test').should be == 0
  end

end