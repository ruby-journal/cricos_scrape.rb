class BulkImportInstitution
  def self.get(id_min, id_max, id_file)
    institution_importer = CricosScrape::InstitutionImporter.new

    institutions_file = JsonFileStore.new('institutions.json')
    institution_ids_file = JsonFileStore.new('institution_ids.json')

    id_range = id_file.nil? ? (id_min..id_max) : File.read(id_file).split(",").map { |s| s.to_i }
    
    id_range.each do |providerID|
      institution = institution_importer.scrape_institution(providerID)

      if !institution.nil?
        institutions_file.save(institution)
        institution_ids_file.save(providerID)
        puts "Success with ProviderID #{providerID}"
      end
    end
  end
end