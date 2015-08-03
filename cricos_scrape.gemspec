require './lib/cricos_scrape/version'

Gem::Specification.new do |spec|
  spec.name          = 'cricos_scrape'
  spec.version       = CricosScrape::VERSION
  spec.authors       = ['Trung Lê', 'Toàn Lê']
  spec.email         = ['trung.le@ruby-journal.com', 'ktoanlba@gmail.com']
  spec.summary       = %q{CRICOS Scrape}
  spec.description   = %q{Scrape Institutions, Courses, Contacts from CRICOS}
  spec.homepage      = 'https://github.com/ruby-journal/cricos_scrape.rb'
  spec.license       = 'MIT'

  spec.files         = Dir['[A-Z]*',
                        'lib/*.rb',
                        'lib/cricos_scrape/*.rb',
                        'spec/*.rb',
                        'spec/fixtures/*.html']

  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'

  spec.add_runtime_dependency 'mechanize', '>= 2.7.2'

  spec.required_ruby_version = '>= 2.2.2'
end
