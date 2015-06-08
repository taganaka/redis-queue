require 'rubygems'
require 'bundler'
require 'rspec'


RSpec.configure do |config|
  config.color = true
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'redis-queue'