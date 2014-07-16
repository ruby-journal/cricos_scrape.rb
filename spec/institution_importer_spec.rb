require 'spec_helper'

describe CricosScrape::InstitutionImporter do

  describe '#scrape_institution' do
    let(:agent) { CricosScrape::InstitutionImporter.new }
    subject(:institution) { agent.scrape_institution(1) }
    before do
      allow(agent).to receive(:url_for).with(1).and_return(uri)
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

      context 'when the response body not contains pagination location' do
        its(:locations) do
          is_expected.to eq [Location.new('123', 'Australian Catholic University', 'ACT', '42')]
        end
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

      context 'when the response body contains pagination location' do
        its(:locations) do
          data = [
            Location.new("456", "ACT Education and Training Directorate", "ACT", "2"),
            Location.new("456", "Alfred Deakin High School", "ACT", "1"),
            Location.new("456", "Amaroo School", "ACT", "1"),
            Location.new("456", "Belconnen High", "ACT", "1"),
            Location.new("456", "Campbell High School", "ACT", "1"),
            Location.new("456", "Canberra College", "ACT", "1"),
            Location.new("456", "Canberra High School", "ACT", "1"),
            Location.new("456", "Caroline Chisholm School", "ACT", "1"),
            Location.new("456", "Dickson College", "ACT", "1"),
            Location.new("456", "Erindale College", "ACT", "1"),

            Location.new("456", "ACT Education and Training Directorate", "ACT", "2"),
            Location.new("456", "Alfred Deakin High School", "ACT", "1"),
            Location.new("456", "Amaroo School", "ACT", "1"),
            Location.new("456", "Belconnen High", "ACT", "1"),
            Location.new("456", "Campbell High School", "ACT", "1"),
            Location.new("456", "Canberra College", "ACT", "1"),
            Location.new("456", "Canberra High School", "ACT", "1"),
            Location.new("456", "Caroline Chisholm School", "ACT", "1"),
            Location.new("456", "Dickson College", "ACT", "1"),
            Location.new("456", "Erindale College", "ACT", "1"),

            Location.new("456", "ACT Education and Training Directorate", "ACT", "2"),
            Location.new("456", "Alfred Deakin High School", "ACT", "1"),
            Location.new("456", "Amaroo School", "ACT", "1"),
            Location.new("456", "Belconnen High", "ACT", "1"),
            Location.new("456", "Campbell High School", "ACT", "1"),
            Location.new("456", "Canberra College", "ACT", "1"),
            Location.new("456", "Canberra High School", "ACT", "1"),
            Location.new("456", "Caroline Chisholm School", "ACT", "1"),
            Location.new("456", "Dickson College", "ACT", "1"),
            Location.new("456", "Erindale College", "ACT", "1"),
          ]
          is_expected.to eq data
        end
      end
    end
  end

end
