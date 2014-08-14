module CricosScrape
  class BulkImportInstitutions
    attr_reader :output, :min_id, :max_id, :input

    def initialize(output, min_id, max_id, input=nil)
      @range = input ? convert_ids_from_file_to_array(input) : (min_id..max_id).to_a
      return 'Invalid Range ID' if @range.empty?

      @importer = CricosScrape::InstitutionImporter.new
      @institutions_file = CricosScrape::JsonFileStore.new(output['data'])
      @institution_ids_file = CricosScrape::JsonFileStore.new(output['ids'])
    end

    def perform
      @range.each do |providerID|
        scrape_institution_and_save_to_file(providerID)
      end
    end

    private
    def scrape_institution_and_save_to_file(providerID)
      institution = @importer.scrape_institution(providerID)
      if institution
        save_institution_data_to_file(providerID, institution)
      else
        puts "The Provider ID #{providerID} entered is invalid - please try another."
      end
    end

    def save_institution_data_to_file(providerID, institution)
      @institution_ids_file.save(providerID)
      @institutions_file.save(institution)
      puts "Success with ProviderID #{providerID}"
    rescue => e
      @institutions_file.rollback
      @institution_ids_file.rollback
      puts "Error writing to files with ProviderID #{providerID}"
    end

    def convert_ids_from_file_to_array(input)
      File.read(input).split(",").map { |s| s.to_i } rescue []
    end
  end
end