require 'spec_helper'

describe Redis::Queue do
  it 'should return correct version string' do
    Redis::Queue.version.should == "redis-queue version #{Redis::Queue::VERSION}"
  end
end