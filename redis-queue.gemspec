# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require File.expand_path('lib/redis/queue', __dir__)

Gem::Specification.new do |s|
  s.name        = 'redis-queue'
  s.version     = Redis::Queue::VERSION
  s.authors     = ['Francesco Laurita']
  s.email       = ['francesco.laurita@gmail.com']
  s.homepage    = 'https://github.com/taganaka/redis-queue'
  s.summary     = 'A distributed queue based on Redis'
  s.description = '
    Adds Redis::Queue class which can be used as Distributed-Queue based on Redis.
    Redis is often used as a messaging server to implement processing of background jobs or other kinds of messaging tasks.
    It implements Reliable-queue pattern decribed here: http://redis.io/commands/rpoplpush
  '

  s.licenses = ['MIT']

  s.rubyforge_project = 'redis-queue'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'redis', '>= 3.3.5', '<= 5'

  s.add_development_dependency 'rspec', '~> 2.13', '>= 2.13.0'
end
