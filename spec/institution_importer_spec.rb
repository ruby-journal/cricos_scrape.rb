require 'spec_helper'

describe CricosScrape::InstitutionImporter do

  describe '#scrape_institution' do
    let(:agent) { CricosScrape::InstitutionImporter.new }
    subject(:institution) { agent.scrape_institution(1) }
    before do
      allow(agent).to receive(:url_for).with(1).and_return(uri)

      @fake_agent = Mechanize.new
      
      courses_list_page = @fake_agent.get(institution_details_with_pagination_location_page_1_uri+"?LocationID=456")
      allow_any_instance_of(Mechanize::Form).to receive(:submit).with(nil, {'action' => 'get-location-id'}).and_return(courses_list_page)
    end

    context 'when there is no institution found' do
      let(:uri) { not_found_institution_details_uri }

      it 'does not import' do
        expect(institution).to be_nil
      end
    end

    context 'when the response body contains Institution Trading Name' do
      let(:uri) { institution_details_with_trading_name_uri }

      its(:provider_code) { is_expected.to eq '00873F' }
      its(:trading_name) { is_expected.to eq 'Australian Catholic University Limited' }
      its(:name) { is_expected.to eq 'Australian Catholic University Limited' }
      its(:type) { is_expected.to eq 'Government' }
      its(:total_capacity) { is_expected.to eq 50 }
      its(:website) { is_expected.to eq 'www.acu.edu.au' }
      its(:postal_address) do
        is_expected.to eq Address.new('International Education Office', 'PO Box 968', 'NORTH SYDNEY', 'New South Wales', '2059')
      end
    end

    context 'when the response body does not contains Address Line 2' do
      let(:uri) { institution_details_with_po_box_postal_address_uri }

      its(:provider_code) { is_expected.to eq '00780M' }
      its(:trading_name) { is_expected.to be_nil }
      its(:name) { is_expected.to eq 'Department of Education' }
      its(:type) { is_expected.to eq 'Government' }
      its(:total_capacity) { is_expected.to eq 500 }
      its(:website) { is_expected.to be_nil }
      its(:postal_address) do
        is_expected.to eq Address.new('GPO Box 4821', nil, 'DARWIN', 'Northern Territory', '0801')
      end
    end

    context 'when the response body contains both Principal Executive Officer and International Student Contact' do
      let(:uri) { institution_details_without_pagination_location_uri }

      its(:contact_officers) do
        data = [
          ContactOfficer.new('Principal Executive Officer', 'Matthew Green', 'Principal', '0889506400', '0889524607', nil),
          ContactOfficer.new('International Student Contact', 'ROCHELLE Marshall', 'Secretary', '0889506400', '0889524607', 'rochelle.marshall@nt.catholic.edu.au')
        ]
        is_expected.to eq data
      end
    end

    context 'when the response body only contains Principal Executive Officer' do
      let(:uri) { institution_details_with_po_box_postal_address_uri }

      its(:contact_officers) do
        is_expected.to eq [ContactOfficer.new('Principal Executive Officer', 'Rachael Shanahan', 'Director, Education Services', '0889011336', '0889995788', nil)]
      end
    end

    context 'when the response body not contains pagination location' do
      let(:uri) { institution_details_without_pagination_location_uri }
      
      its(:locations) do
        locations = [
          Location.new("456", 'Bath Street Campus', 'NT', '1'),
          Location.new("456", 'Sadadeen Campus', 'NT', '2'),
          Location.new("456", 'Traeger Campus', 'NT', '2') ,
        ]
        is_expected.to eq locations
      end
    end

    context 'when the response body not contains location details' do
      let(:uri) { institution_details_without_locations_details_uri }
      
      its(:locations) do
        is_expected.to eq nil
      end
    end

    context 'when the response body contains pagination location' do
      let(:uri) { institution_details_with_pagination_location_page_1_uri }

      before do
        # Method jump_to_page don't jump to current page (page 1). with total_pages=2, form will submit once
        locations_list_page_2 = @fake_agent.get(institution_details_with_pagination_location_page_2_uri)
        allow_any_instance_of(Mechanize::Form).to receive(:submit).with(nil, {'action' => 'change-location-page'}).and_return(locations_list_page_2)
      end

      its(:locations) do
        locations = [
          #Locations on page 1
          Location.new("456", "Albury", "NSW", "51"),
          Location.new("456", "Bathurst", "NSW", "60"),
          Location.new("456", "Canberra Institute of Technology - City Campus", "ACT", "2"),
          Location.new("456", "CSU Study Centre Melbourne", "VIC", "22"),
          Location.new("456", "CSU Study Centre Sydney", "NSW", "21"),
          Location.new("456", "Dubbo", "NSW", "29"),
          Location.new("456", "Holmesglen Institute of TAFE", "VIC", "3"),
          Location.new("456", "Orange", "NSW", "41"),
          Location.new("456", "Ryde", "NSW", "1"),
          Location.new("456", "St Marks Theological Centre", "ACT", "12"),

          #Locations on page 2
          Location.new("456", "United Theological College", "NSW", "11"),
          Location.new("456", "Wagga Wagga", "NSW", "105"),
        ]
        is_expected.to eq locations
      end

      context 'when the contact officers contains table grid' do
        its(:contact_officers) do
          data = [
            ContactOfficer.new('Principal Executive Officer', 'Andrew Vann', 'Vice-Chancellor', '02 6338 4209', '02 6338 4809', nil),
            ContactOfficer.new('International Student Contact', 'Matthew Evans', nil, '02 63657537', '02 63657590', 'mevans@csu.edu.au'),
            ContactOfficer.new('International Student Contact', 'Matthew Evans', nil, '02 6365 7537', '02 6365 7590', 'mevans@csu.edu.au')
          ]
          is_expected.to eq data
        end
      end
    end
  end

end
