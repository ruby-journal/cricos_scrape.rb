require_relative 'lib/cricos_scrape/version'

Gem::Specification.new do |spec|
  spec.name          = 'cricos_scrape'
  spec.version       = CricosScrape::VERSION
  spec.authors       = ['Toàn Lê']
  spec.email         = ['ktoanlba@gmail.com']
  spec.summary       = %q{Cricos Scrape}
  spec.description   = %q{Scrape Institutions, Courses, Contacts from CRIOS}
  spec.homepage      = 'https://github.com/ruby-journal/cricos_scrape.rb'
  spec.license       = 'MIT'

  spec.files         = Dir['[A-Z]*',
                        'lib/*.rb',
                        'lib/cricos_scrape/*.rb',
                        'spec/*.rb',
                        'spec/fixtures/*.html']

  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'

  spec.add_runtime_dependency 'mechanize', '~> 2.7'
end