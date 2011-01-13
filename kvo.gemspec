# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kvo/version"

Gem::Specification.new do |s|
  s.name        = "kvo"
  s.version     = Kvo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Shawn Anderson"]
  s.email       = ["shawn42@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{KVO in ruby}
  s.description = %q{KVO in ruby.}

  s.rubyforge_project = "kvo"

  s.add_dependency 'publisher'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
