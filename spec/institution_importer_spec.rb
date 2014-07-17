require 'spec_helper'

describe CricosScrape::InstitutionImporter do

  describe '#scrape_institution' do
    let(:agent) { CricosScrape::InstitutionImporter.new }
    subject(:institution) { agent.scrape_institution(1) }
    before do
      allow(agent).to receive(:url_for).with(1).and_return(uri)

      fake_agent = Mechanize.new
      @location_id = "456"
      allow_any_instance_of(Mechanize).to receive(:submit).and_return(fake_agent.get("#{uri}?LocationID=#{@location_id}"))
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

      its(:provider_code) { is_expected.to eq '00643J' }
      its(:trading_name) { is_expected.to be_nil }
      its(:name) { is_expected.to eq 'ACT Education and Training Directorate' }
      its(:type) { is_expected.to eq 'Government' }
      its(:total_capacity) { is_expected.to eq 940 }
      its(:website) { is_expected.to be_nil }
      its(:postal_address) do
        is_expected.to eq Address.new('GPO Box 158', nil, 'CANBERRA ACT', 'Australian Capital Territory', '2601')
      end
    end


    context 'when the response body not contains pagination location' do
      let(:uri) { institution_details_without_pagination_location_uri }

      its(:locations) do
        locations = [
          Location.new(@location_id, 'Bath Street Campus', 'NT', '1'),
          Location.new(@location_id, 'Sadadeen Campus', 'NT', '2'),
          Location.new(@location_id, 'Traeger Campus', 'NT', '2') ,
        ]
        is_expected.to eq locations
      end
    end

    context 'when the response body contains pagination location' do
      let(:uri) { institution_details_with_pagination_location_uri }

      its(:locations) do
        #duplicate data because total page is 2. The same page is loaded twice
        locations = [
          #Locations on page 1
          Location.new(@location_id, "Albury", "NSW", "51"),
          Location.new(@location_id, "Bathurst", "NSW", "60"),
          Location.new(@location_id, "Canberra Institute of Technology - City Campus", "ACT", "2"),
          Location.new(@location_id, "CSU Study Centre Melbourne", "VIC", "22"),
          Location.new(@location_id, "CSU Study Centre Sydney", "NSW", "21"),
          Location.new(@location_id, "Dubbo", "NSW", "29"),
          Location.new(@location_id, "Holmesglen Institute of TAFE", "VIC", "3"),
          Location.new(@location_id, "Orange", "NSW", "41"),
          Location.new(@location_id, "Ryde", "NSW", "1"),
          Location.new(@location_id, "St Marks Theological Centre", "ACT", "12"),

          #Locations on page 2
          Location.new(@location_id, "Albury", "NSW", "51"),
          Location.new(@location_id, "Bathurst", "NSW", "60"),
          Location.new(@location_id, "Canberra Institute of Technology - City Campus", "ACT", "2"),
          Location.new(@location_id, "CSU Study Centre Melbourne", "VIC", "22"),
          Location.new(@location_id, "CSU Study Centre Sydney", "NSW", "21"),
          Location.new(@location_id, "Dubbo", "NSW", "29"),
          Location.new(@location_id, "Holmesglen Institute of TAFE", "VIC", "3"),
          Location.new(@location_id, "Orange", "NSW", "41"),
          Location.new(@location_id, "Ryde", "NSW", "1"),
          Location.new(@location_id, "St Marks Theological Centre", "ACT", "12"),
        ]
        is_expected.to eq locations
      end
    end
  end

end
