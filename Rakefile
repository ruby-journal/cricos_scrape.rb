require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require_relative 'lib/cricos_scrape'
namespace :import do
  task :contacts do
    output_file  = ENV['OUTPUT_FILE'] || 'contacts.json'
    CricosScrape::BulkImportContacts::new(output_file, ENV['OVERWRITE']).perform
  end
end
