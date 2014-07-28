class BulkImportInstitutions
  attr_reader :id_min, :id_max, :id_file

  def initialize(id_min, id_max, id_file)
    @id_min ,@id_max ,@id_file = [id_min, id_max, id_file]

    @institution_importer = CricosScrape::InstitutionImporter.new

    @institutions_file = JsonFileStore.new('institutions.json')
    @institution_ids_file = JsonFileStore.new('institution_ids.json')
  end

  def perform
    id_range.each do |providerID|
      scrape_institution_and_save_to_file(providerID)
    end
  end

  private
  def scrape_institution_and_save_to_file(providerID)
    @institution = @institution_importer.scrape_institution(providerID)

    if institution_is_exist?
      @institutions_file.save(@institution)
      @institution_ids_file.save(providerID)

      puts "Success with ProviderID #{providerID}"
    end
  end

  def id_range
    @id_file.nil? ? (@id_min..@id_max) : convert_ids_from_file_to_array
  end

  def convert_ids_from_file_to_array
    File.read(@id_file).split(",").map { |s| s.to_i }
  end

  def institution_is_exist?
    !!@institution
  end
end