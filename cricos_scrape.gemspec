# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cricos_scrape/version'

Gem::Specification.new do |spec|
  spec.name          = 'cricos_scrape'
  spec.version       = CricosScrape::VERSION
  spec.authors       = ['Trung Lê', 'Toàn Lê']
  spec.email         = ['trung.le@ruby-journal.com', 'ktoanlba@gmail.com']
  spec.summary       = %q{CRICOS Scrape}
  spec.description   = %q{Scrape Institutions, Courses, Contacts from CRICOS}
  spec.homepage      = 'https://github.com/ruby-journal/cricos_scrape.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z -- lib/* bin/* LICENSE.md README.md cricos_scrape.gemspec`.split("\x0")
  spec.executables   = ['cricos_scrape']
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.required_ruby_version = '>= 3.0.0'

  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.3.0', '>= 3.3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0', '>= 1.2.0'

  spec.add_runtime_dependency 'mechanize', '~> 2.7', '>= 2.7.2'
  spec.add_runtime_dependency 'slop', '~> 4.2.0', '>= 4.2.0'

  spec.add_dependency 'commander', '~> 4.3'
end
