require_relative './importer/institution_importer'
require_relative './agent'

module CricosScrape
  class BulkImportInstitutions
    def initialize(min_id=0, max_id=10000)
      @range = (min_id..max_id).to_a
      @agent = CricosScrape.agent
    end

    def perform
      @range.each do |provider_id|
        scrape(provider_id)
      end
    end

    private

    attr_reader :min_id, :max_id, :agent

    def scrape(provider_id)
      institution = InstitutionImporter.new(agent, provider_id: provider_id).run

      if institution
        puts institution.to_json
      else
        STDERR.puts "Could not find institution with Provider ID #{provider_id}"
      end
    end
  end
end