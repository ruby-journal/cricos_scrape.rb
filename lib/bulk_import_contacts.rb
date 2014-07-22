class BulkImportContact
	def self.get
		contacts_file = JsonFileStore.new('contacts.json')

		if contacts_file.data_file_empty?
			contact_importer = CricosScrape::ContactImporter.new
			contact = contact_importer.scrape_contact
			
			contacts_file.save(contact)

			puts "Success to get Contacts"
		else
			puts "Contacts have been taken"
		end
	end
end