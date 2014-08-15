module CricosScrape
  class ContactImporter

    CONTACT_URL = 'http://cricos.deewr.gov.au/Contacts/CRICOSContacts.aspx'
    STATES_CODE = ['ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA']

    attr_reader :agent
    private :agent

    def initialize
      @agent = Mechanize.new
    end

    def scrape_contact
      contacts = []

      for state in STATES_CODE
        @page = agent.get(url_for(state))
        if exist_contacts_of_state?
          @table_contains_contact = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetDetails_cricosContactDetails_pnlContactLists table').children

          number_of_rows_per_contact = 18
          start_contact_row = 3
          end_contact_row = @table_contains_contact.count - number_of_rows_per_contact
          
          for i in (start_contact_row..end_contact_row).step(number_of_rows_per_contact)
            @row_index = i

            contact = CricosScrape::Contact.new
            contact.type_of_course = find_type_of_course
            contact.name = find_name
            contact.organisation = find_organisation
            contact.postal_address = find_postal_address
            contact.telephone = find_telephone
            contact.facsimile = find_facsimile
            contact.email = find_email

            contacts << contact
          end
        end
      end

      contacts
    end

    private
    def url_for(state_code)
      "#{CONTACT_URL}?StateCode=#{state_code}"
    end

    def exist_contacts_of_state?
      !!@page.at('#__tab_ctl00_cphDefaultPage_tabContainer_sheetDetails')
    end

    def find_value_of_field(field)
      field.nil? ? nil : field.text.strip
    end

    def find_type_of_course
      find_value_of_field(@table_contains_contact[@row_index])
    end

    def find_name
      name_row = @table_contains_contact[@row_index+4].children
      find_value_of_field(name_row[3]).empty? ? find_value_of_field(name_row[2]) : find_value_of_field(name_row[3])
    end

    def find_organisation
      organisation_row = @table_contains_contact[@row_index+6].children
      find_value_of_field(organisation_row[3])
    end

    def find_postal_address
      address = CricosScrape::Address.new

      address_row = @table_contains_contact[@row_index+8].children
      postal_address_cell = address_row[3].children
      address.address_line_1 = find_value_of_field(postal_address_cell[0])
      address.suburb, address.state, address.postcode = extract_suburb_and_state_and_postcode_from(find_value_of_field(postal_address_cell[2]))

      address
    end

    def extract_suburb_and_state_and_postcode_from(line)
      line.scan(/^(.*)\s(#{australia_states_code_regex})\s(#{australia_postcode_regex})$/).first
    end

    def australia_states_code_regex
      'ACT|NSW|NT|QLD|SA|TAS|VIC|WA'
    end

    def australia_postcode_regex
      '\d{4}'
    end

    def find_telephone
      telephone_row = @table_contains_contact[@row_index+10].children
      find_value_of_field(telephone_row[3])
    end

    def find_facsimile
      facsimile_row = @table_contains_contact[@row_index+12].children
      find_value_of_field(facsimile_row[3])
    end

    def find_email
      email_row = @table_contains_contact[@row_index+14].children
      find_value_of_field(email_row[3])
    end
  end
end
