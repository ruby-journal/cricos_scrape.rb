class BulkImportInstitutions
  attr_reader :output, :min_id, :max_id, :input

  def initialize(output, min_id, max_id, input=nil)
    @range = input ? convert_ids_from_file_to_array(input) : (min_id..max_id)
    return error_notice if @range.empty?

    @importer = CricosScrape::InstitutionImporter.new
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
    institution = @importer.scrape_institution(providerID)
    
    if institution
      save_institution_data_to_file
    else
      error_notice
    end
  end

  def save_institution_data_to_file
    @institutions_file.save(institution)
    @institution_ids_file.save(providerID)
  rescue => e
    @institutions_file.rollback
    @institution_ids_file.rollback
    error_notice
  end

  def error_notice
    puts "An error occurred with ProviderID #{providerID}"
  end

  def convert_ids_from_file_to_array(input)
    File.read(input).split(",").map { |s| s.to_i }
  rescue => e
    puts "Wrong input format file"
  end
end