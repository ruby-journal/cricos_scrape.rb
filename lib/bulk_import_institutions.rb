class BulkImportInstitutions
  attr_reader :results_file, :id_min, :id_max, :id_file

  def initialize(results_file, id_min, id_max, id_file)
    @id_min, @id_max, @id_file = [id_min, id_max, id_file]
    @institution_importer = CricosScrape::InstitutionImporter.new
    @institutions_file = JsonFileStore.new(results_file['data'])
    @institution_ids_file = JsonFileStore.new(results_file['ids'])
  end

  def perform
    id_range.each do |providerID|
      puts "Success with ProviderID #{providerID}" if scrape_institution_and_save_to_file(providerID)
    end
  end

  private
  def scrape_institution_and_save_to_file(providerID)
    @institution = @institution_importer.scrape_institution(providerID)
    
    if institution_existed?
      @institutions_file.save(@institution)
      @institution_ids_file.save(providerID)
    else
      return false
    end
  rescue => e
    puts "An error occurred with ProviderID #{providerID}"
  end

  def id_range
    @id_file.nil? ? (@id_min..@id_max) : convert_ids_from_file_to_array
  end

  def convert_ids_from_file_to_array
    File.read(@id_file).split(",").map { |s| s.to_i }
  end

  def institution_existed?
    !!@institution
  end
end