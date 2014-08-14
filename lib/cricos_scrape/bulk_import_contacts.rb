module CricosScrape
  class BulkImportContacts
    attr_reader :overwrite

    def initialize(results_file, overwrite = false)
      @overwrite = overwrite
      @contacts_file = CricosScrape::JsonFileStore.new(results_file)
      @contact_importer = CricosScrape::ContactImporter.new
    end

    def perform
      if should_create_new_data_contacts_file?
        scrape_contact_and_save_to_file
      else
        puts "Contacts have been taken"
      end
    end

    private
    def scrape_contact_and_save_to_file
      contacts = @contact_importer.scrape_contact
      @contacts_file.save(contacts, @overwrite)
      puts "Success to get Contacts"
    rescue => e
      puts "An error occurred when scrape contacts"
    end

    def should_create_new_data_contacts_file?
      @contacts_file.file_empty? || @overwrite
    end
  end
end