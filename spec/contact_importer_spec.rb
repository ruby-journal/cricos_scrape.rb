require 'spec_helper'

describe CricosScrape::ContactImporter do

  describe '#scrape_contact' do
    let(:agent) { CricosScrape::ContactImporter.new }
    before do
      stub_const("CricosScrape::ContactImporter::STATES_CODE", ['ACT', 'WA'])
      
      allow(agent).to receive(:url_for).with('ACT').and_return(contact_details_of_state_act_uri)
      allow(agent).to receive(:url_for).with('WA').and_return(contact_details_of_state_wa_uri)
      
      @contacts = agent.scrape_contact
    end

    context 'when the response body contains with states ACT and WA' do
      it 'returns array contacts array' do
        data = [
          #contacts of ACT
          Contact.new('School Courses (and ELICOS and Foundation Programs where delivered by a school)', 
            'Ms Rebecca Hughes', 
            'ACT Education and Training Directorate', 
            Address.new('GPO Box 158', nil, 'CANBERRA', 'ACT', '2601'), 
            '0262059299', 
            '', 
            'etd.contactus@act.gov.au'
          ),
          Contact.new('Vocational Courses (and ELICOS courses offered by an RTO or remaining ‘stand-alone’ ELICOS provider)', 
            'ASQA Info Line', 
            'Australian Skills Quality Authority', 
            Address.new('PO Box 9928', nil, 'Melbourne', 'VIC', '3001'), 
            '1300701801', 
            '', 
            'enquiries@asqa.gov.au'
          ),
          Contact.new('Higher Education Courses (and ELICOS and  Foundation Programs where delivered in a pathway arrangement with a Higher Education Provider)', 
            'Tertiary Education Quality and Standards Agency', 
            'Tertiary Education Quality and Standards Agency', 
            Address.new('GPO Box 1672', nil, 'Melbourne', 'VIC', '3001'), 
            '1300739585', 
            '1300739586', 
            'enquiries@teqsa.gov.au'
          ),
          #contacts of WA
          Contact.new('Vocational Courses (and ELICOS courses offered by an RTO or remaining ‘stand-alone’ ELICOS provider)', 
            'ASQA Info Line', 
            'Australian Skills Quality Authority', 
            Address.new('PO Box 9928', nil, 'Melbourne', 'VIC', '3001'), 
            '1300701801', 
            '', 
            'enquiries@asqa.gov.au'
          ),
          Contact.new('School Courses (and ELICOS and Foundation Programs where delivered by a school)', 
            'Mr Steve Page Senior Registration and Policy Officer', 
            'Department of Education Services, Non-Government & International Education Directorate', 
            Address.new('PO Box 1766', nil, 'OSBORNE PARK', 'WA', '6916'), 
            '0894411962', 
            '0894411901', 
            'ngs@des.wa.gov.au'
          ),
          Contact.new('Higher Education Courses (and ELICOS and  Foundation Programs where delivered in a pathway arrangement with a Higher Education Provider)', 
            'Tertiary Education Quality and Standards Agency', 
            'Tertiary Education Quality and Standards Agency', 
            Address.new('GPO Box 1672', nil, 'Melbourne', 'VIC', '3001'), 
            '1300739585', 
            '1300739586', 
            'enquiries@teqsa.gov.au'
          ),
        ]

        expect(@contacts).to eq data
      end
    end
  end
end