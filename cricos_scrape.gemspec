# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cricos_scrape/version'

Gem::Specification.new do |spec|
  spec.name          = 'cricos_scrape'
  spec.version       = CricosScrape::VERSION
  spec.authors       = ['Toàn Lê']
  spec.email         = ['ktoanlba@gmail.com']
  spec.summary       = %q{Cricos Scrape}
  spec.description   = %q{Scrape Institutions, Courses, Contacts from Cricos}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = ['Gemfile',
                        'Gemfile.lock',
                        'README.md',
                        'cricos_scrape.gemspec',
                        'lib/bulk_import_contacts.rb',
                        'lib/bulk_import_courses.rb',
                        'lib/bulk_import_institutions.rb',
                        'lib/cricos_scrape.rb',
                        'lib/cricos_scrape/address.rb',
                        'lib/cricos_scrape/contact.rb',
                        'lib/cricos_scrape/contact_importer.rb',
                        'lib/cricos_scrape/contact_officer.rb',
                        'lib/cricos_scrape/course.rb',
                        'lib/cricos_scrape/course_importer.rb',
                        'lib/cricos_scrape/institution.rb',
                        'lib/cricos_scrape/institution_importer.rb',
                        'lib/cricos_scrape/json_file_store.rb',
                        'lib/cricos_scrape/json_struct.rb',
                        'lib/cricos_scrape/location.rb',
                        'lib/cricos_scrape/version.rb',
                        'rakefile',
                        'spec/bulk_import_contacts_spec.rb',
                        'spec/bulk_import_courses_spec.rb',
                        'spec/bulk_import_institutions_spec.rb',
                        'spec/contact_importer_spec.rb',
                        'spec/course_importer_spec.rb',
                        'spec/fixtures/contact_details_of_state_act_uri.html',
                        'spec/fixtures/contact_details_of_state_wa_uri.html',
                        'spec/fixtures/course_details_without_pagination_uri.html',
                        'spec/fixtures/courses_list_by_location_id_uri.html',
                        'spec/fixtures/institution_details_with_pagination_location_page_1_uri.html',
                        'spec/fixtures/institution_details_with_pagination_location_page_2_uri.html',
                        'spec/fixtures/institution_details_with_po_box_postal_address.html',
                        'spec/fixtures/institution_details_with_trading_name.html',
                        'spec/fixtures/institution_details_without_pagination_location_uri.html',
                        'spec/fixtures/not_found_course_details_uri.html',
                        'spec/fixtures/not_found_institution_details.html',
                        'spec/institution_importer_spec.rb',
                        'spec/json_file_store_spec.rb',
                        'spec/spec_helper.rb']

  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'

  spec.add_runtime_dependency 'mechanize'
end
