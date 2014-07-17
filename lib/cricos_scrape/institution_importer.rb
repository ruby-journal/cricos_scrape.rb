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

      if location_results_paginated?
        for page_number in 1..total_pages
          jump_to_page(page_number)
          locations += fetch_locations_from_current_page
        end
      else
        locations += fetch_locations_from_current_page
      end
      
      locations
    end

    def pagination
      @page.at('#locationList_gridSearchResults .gridPager')
    end

    def location_results_paginated?
      !!pagination
    end

    def total_pages
      pagination.children[1].text.strip.scan(/^Page [0-9]+ of ([0-9]+).*/).first.first.to_i
    end

    def current_pagination_page
      pagination.children[1].text.strip.scan(/^Page ([0-9]+) of [0-9]+.*/).first.first.to_i
    end

    def jump_to_page(page_number)
      return @page if page_number == current_pagination_page

      hidden_form = @page.form_with :id => "Form1"
      hidden_form['__EVENTTARGET'] = 'locationList$gridSearchResults'
      hidden_form['__EVENTARGUMENT'] = "Page$#{page_number}"
      @page = agent.submit hidden_form
    end

    def get_location_id(row_index)
      hidden_form = @page.form_with :id => "Form1"
      hidden_form['__EVENTTARGET'] = 'locationList$gridSearchResults'
      hidden_form['__EVENTARGUMENT'] = "click-#{row_index-3}"
      course_page = agent.submit hidden_form

      course_page.uri.to_s.scan(/LocationID=([0-9]+)/).first.first
    end

    def fetch_locations_from_current_page
      locations_of_page = []

      # location_list is table contains locations in current page
      location_list = @page.at('#locationList_gridSearchResults').children

      excess_row_at_the_end_table = location_results_paginated? ? 3 : 2
      start_location_row = 3
      end_location_row = location_list.count - excess_row_at_the_end_table

      for i in start_location_row..end_location_row
        location_row = location_list[i].children

        location_obj = Location.new
        location_obj.location_id = get_location_id(i)
        location_obj.name = find_value_of_field(location_row[1])
        location_obj.state = find_value_of_field(location_row[2])
        location_obj.number_of_courses = find_value_of_field(location_row[3])

        locations_of_page << location_obj
      end

      locations_of_page
    end

  end
end
