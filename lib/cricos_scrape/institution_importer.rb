require 'rubygems'
require 'mechanize'

class Institution < Struct.new(:provider_code, :trading_name, :name, :type, :total_capacity, :postal_address, :website)
end

class Address < Struct.new(:address_line_1, :address_line_2, :suburb, :state, :postcode)
end

module CricosScrape
  class InstitutionImporter

    INSTITUTION_URL = 'http://cricos.deewr.gov.au/Institution/InstitutionDetails.aspx'

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
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblProviderCode')
      find_value_of_field(field)
    end

    def find_trading_name
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblInstitutionTradingName')
      find_value_of_field(field)
    end

    def find_name
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblInstitutionName')
      find_value_of_field(field)
    end

    def find_type
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblInstitutionType')
      find_value_of_field(field)
    end

    def find_total_capacity
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblLocationCapacity')

      capacity = find_value_of_field(field)
      capacity = is_number?(capacity) ? capacity.to_i : nil
      capacity
    end

    def is_number?(text)
      text =~ /\d/
    end

    def find_website
      field = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_hplInstitutionWebAddress')
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

      address_lines = @page.at('#ctl00_cphDefaultPage_tabContainer_sheetInstitutionDetail_institutionDetail_lblInstitutionPostalAddress').children.select { |node| node.is_a?(Nokogiri::XML::Text) }.map { |node| find_value_of_field(node) }

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
      @page.at('#contentBody h1').text == 'Education Institution Search'
    end

  end
end
