# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cricos_scrape/version'

Gem::Specification.new do |spec|
  spec.name          = "cricos_scrape"
  spec.version       = CricosScrape::VERSION
  spec.authors       = ["Toàn Lê"]
  spec.email         = ["ktoanlba@gmail.com"]
  spec.summary       = %q{Cricos Scrape}
  spec.description   = %q{Scrape Institutions, Courses, Contacts from Cricos}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'

  spec.add_runtime_dependency 'mechanize'
end
