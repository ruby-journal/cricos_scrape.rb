class BulkImportContacts
  attr_reader :results_file

  def initialize(results_file, overwrite = false)
    @overwrite = overwrite

    @contacts_file = JsonFileStore.new(results_file)

    @contact_importer = CricosScrape::ContactImporter.new
  end

  def perform
    if create_new_data_contacts_file?
      scrape_contact_and_save_to_file

      puts "Success to get Contacts"
    else
      puts "Contacts have been taken"
    end
  end

  private
  def scrape_contact_and_save_to_file
    contacts = @contact_importer.scrape_contact
    @contacts_file.save(contacts)
  end

  def create_new_data_contacts_file?
    @contacts_file.data_file_empty? || @overwrite
  end
end