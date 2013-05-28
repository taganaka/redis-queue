require 'rubygems'
require 'bundler'
require 'rspec'


RSpec.configure do |config|
  config.color_enabled = true
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'redis-queue'