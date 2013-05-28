# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis-queue"

Gem::Specification.new do |s|
  s.name        = "redis-queue"
  s.version     = Redis::Queue::VERSION
  s.authors     = ["Francesco Laurita"]
  s.email       = ["taganaka@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "redis-queue"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis", "~> 3.0.4"
  s.add_dependency "hiredis", "~> 0.4.5"
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
