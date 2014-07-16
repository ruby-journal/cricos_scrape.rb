module CricosScrape
  class InstitutionImporter

    INSTITUTION_URL = 'http://cricos.deewr.gov.au/Institution/InstitutionDetailsOnePage.aspx'

    attr_reader :agent
    private :agent

    def initialize
      @agent = Mechanize.new(user_agent_alias: 'Windows IE 9')
    end

    def scrape_institution(provider_id)
      @page = agent.get(url_for(provider_id))

      return if institution_not_found?

      institution = Institution.new
      institution.provider_code  = find_provider_code
      institution.trading_name   = find_trading_name
      institution.name           = find_name
      institution.type           = find_type
      institution.total_capacity = find_total_capacity
      institution.website        = find_website
      institution.postal_address = find_postal_address
      institution.locations      = find_location

      institution
    end

    private

    def url_for(provider_id)
      "#{INSTITUTION_URL}?ProviderID=#{provider_id}"
    end

    def find_value_of_field(field)
      field.nil? ? nil : field.text.strip
    end

    def find_provider_code
      field = @page.at('#institutionDetails_lblProviderCode')
      find_value_of_field(field)
    end

    def find_trading_name
      field = @page.at('#institutionDetails_lblInstitutionTradingName')
      find_value_of_field(field)
    end

    def find_name
      field = @page.at('#institutionDetails_lblInstitutionName')
      find_value_of_field(field)
    end

    def find_type
      field = @page.at('#institutionDetails_lblInstitutionType')
      find_value_of_field(field)
    end

    def find_total_capacity
      field = @page.at('#institutionDetails_lblLocationCapacity')

      capacity = find_value_of_field(field)
      capacity = is_number?(capacity) ? capacity.to_i : nil
      capacity
    end

    def is_number?(text)
      text =~ /\d/
    end

    def find_website
      field = @page.at('#institutionDetails_hplInstitutionWebAddress')
      find_value_of_field(field)
    end

    # Extract address details from text fields
    # Returned text conforms following format:
    #
    # ADDRESS LINE 1
    # ADDRESS LINE 2 (optional)
    # SUBURB
    # STATE  POSTCODE
    #
    # eg:
    #   International Office
    #   Box 826
    #   CANBERRA
    #   Australian Capital Territory  2601
    def find_postal_address
      address = Address.new

      address_lines = @page.at('#institutionDetails_lblInstitutionPostalAddress').children.select { |node| node.is_a?(Nokogiri::XML::Text) }.map { |node| find_value_of_field(node) }

      case address_lines.count
      when 4
        address.address_line_1 = address_lines[0]
        address.address_line_2 = address_lines[1]
        address.suburb         = address_lines[2]
      when 3
        address.address_line_1 = address_lines[0]
        address.suburb         = address_lines[1]
      end

      # last line is always state and postcode
      address.state, address.postcode = extract_state_and_postcode_from(address_lines.last)

      address
    end

    def extract_state_and_postcode_from(line)
      line.scan(/^(#{australia_states_regex}).*(#{australia_postcode_regex})$/).first
    end

    def australia_states_regex
      'New South Wales|Queensland|South Autralia|Victoria|Australian Capital Territory|Northern Territory|Western Australia|Tasmania'
    end

    def australia_postcode_regex
      '\d{4}'
    end

    # there is no record not found page
    # instead a search page is returned
    def institution_not_found?
      find_value_of_field(@page.at('#pnlErrorMessage td:last')) == "The Provider ID entered is invalid - please try another."
    end

    def find_location
      locations = []

      page_list = @page.at('#locationList_gridSearchResults .gridPager')

      #count_page = [start_page, end_page]
      count_page = page_list.nil? ? ["1", "1"] : page_list.children[1].text.strip.scan(/^Page ([0-9]+) of ([0-9]+).*/).first

      for page in (count_page.first)..(count_page.last)

        #submit with __EVENTARGUMENT = Page$#{page} -> get another page list location
        hidden_form = @page.form_with :id => "Form1"
        hidden_form['__EVENTTARGET'] = 'locationList$gridSearchResults'
        hidden_form['__EVENTARGUMENT'] = "Page$#{page}"
        current_page = agent.submit hidden_form

        location_list = current_page.at('#locationList_gridSearchResults').children

        #get row location in current page
        for i in 3..(location_list.count - (page_list.nil? ? 2 : 3))
          location_row = location_list[i].children

          #submit with __EVENTARGUMENT = click-rowindex -> get course page of location
          hidden_form = current_page.form_with :id => "Form1"
          hidden_form['__EVENTTARGET'] = 'locationList$gridSearchResults'
          hidden_form['__EVENTARGUMENT'] = "click-#{i-3}"
          course_list = agent.submit hidden_form

          location_obj = Location.new
          location_obj.id = course_list.uri.to_s.scan(/LocationID=([0-9]+)/).first.first
          location_obj.name = find_value_of_field(location_row[1])
          location_obj.state = find_value_of_field(location_row[2])
          location_obj.number_of_courses = find_value_of_field(location_row[3])

          locations << location_obj
        end
      end

      locations
    end

  end
end
