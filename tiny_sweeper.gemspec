# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiny_sweeper/version'

Gem::Specification.new do |s|
  s.name        = 'tiny_sweeper'
  s.version     = TinySweeper::VERSION
  s.date        = Date.today.to_s

  s.summary     = "A tiny helper to clean your inputs"
  s.description = "
    Tiny Sweeper is a handy way to clean attributes on your Rails models,
    though it's independent of Rails, and can be used in any Ruby project.
    It gives you a light-weight way to override your methods and declare
    how their inputs should be cleaned.
  ".strip.gsub(/^\s*/, '')
  s.homepage    = 'https://github.com/ContinuityControl/tiny_sweeper'
  s.license     = 'ASL2'

  s.authors     = ["Dan Bernier"]
  s.email       = ['dbernier@continuity.net']

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.5"
end
