require 'cricos_scrape/importer/contact_importer'
require 'cricos_scrape/agent'

module CricosScrape
  class ImportContacts
    def initialize
      @agent = CricosScrape.agent
    end

    def perform
      contacts = ContactImporter.new(@agent).run

      if contacts.any?
        contacts.each do |contact|
          puts contact.to_json
        end
      else
        STDERR.puts "Something not right, there is no Contacts returned"
      end
    end
  end
end