class BulkImportInstitutions
  attr_reader :output, :min_id, :max_id, :input

  def initialize(output, min_id, max_id, input=nil)
    @range = input.nil? ? (min_id..max_id) : convert_ids_from_file_to_array(input)
    @institution_importer = CricosScrape::InstitutionImporter.new
    @institutions_file = JsonFileStore.new(output['data'])
    @institution_ids_file = JsonFileStore.new(output['ids'])
  end

  def perform
    @range.each do |providerID|
      puts "Success with ProviderID #{providerID}" if scrape_institution_and_save_to_file(providerID)
    end
  end

  private
  def scrape_institution_and_save_to_file(providerID)
    institution = @institution_importer.scrape_institution(providerID)
    
    if institution
      @institutions_file.save(institution)
      @institution_ids_file.save(providerID)
    else
      return false
    end
  rescue => e
    puts "An error occurred with ProviderID #{providerID}"
  end

  def convert_ids_from_file_to_array(input)
    File.read(input).split(",").map { |s| s.to_i }
  end
end