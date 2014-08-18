require 'spec_helper'

describe CricosScrape::CourseImporter do

  describe '#scrape_course' do
    let(:agent) { CricosScrape::CourseImporter.new }
    subject(:course) { agent.scrape_course(1) }
    before do
      allow(agent).to receive(:url_for).with(1).and_return(uri)

      @fake_agent = Mechanize.new

      course_list_page_1 = @fake_agent.get("#{uri}?LocationID=123")
      course_list_page_2 = @fake_agent.get("#{uri}?LocationID=456")
      allow_any_instance_of(Mechanize::Form).to receive(:submit).with(nil, {'action' => 'get-location-id'}).and_return(course_list_page_1, course_list_page_2)
    end

    context 'when there is no course found' do
      let(:uri) { not_found_course_details_uri }

      it 'does not import' do
        expect(course).to be_nil
      end
    end

    context 'when the details course is found' do
      let(:uri) { course_details_without_pagination_uri }

      its(:course_id) { is_expected.to eq 1 }
      its(:course_name) { is_expected.to eq 'Primary Yrs K-6' }
      its(:course_code) { is_expected.to eq '012395K' }
      its(:dual_qualification) { is_expected.to eq 'No' }
      its(:field_of_education) { is_expected.to eq '' }
      its(:broad_field) { is_expected.to eq '12 - Mixed Field Programmes' }
      its(:narrow_field) { is_expected.to eq '1201 - General Education Programmes' }
      its(:detailed_field) { is_expected.to eq '120101 - General Primary and Secondary Education Programmes' }
      its(:course_level) { is_expected.to eq 'Primary School Studies' }
      its(:foundation_studies) { is_expected.to eq 'No' }
      its(:work_component) { is_expected.to eq 'No' }
      its(:course_language) { is_expected.to eq 'English' }
      its(:duration) { is_expected.to eq '364' }
      its(:total_cost) { is_expected.to eq '66,500' }
      its(:contact_officers) do
        contact_officers = [
          CricosScrape::ContactOfficer.new('Principal Executive Officer', 'Nicole King', 'Manager', '0262056998', '62059239', nil),
          CricosScrape::ContactOfficer.new('International Student Contact', 'PAUL Wang', 'Study Tour Coordinator', '62077293', '', 'paul.wang@act.gov.au'),
        ]
        
        is_expected.to eq contact_officers
      end
    end

    context 'when the response body not contains pagination location' do
      let(:uri) { course_details_without_pagination_uri }

      its(:location_ids) do
        location_ids = ["123", "456"]
        is_expected.to eq location_ids
      end
    end

    context 'when the contact officers contains table grid' do
      let(:uri) { course_details_with_contact_officers_table_grid }
      
      its(:contact_officers) do
        data = [
          CricosScrape::ContactOfficer.new('Principal Executive Officer', 'Andrew Vann', 'Vice-Chancellor', '02 6338 4209', '02 6338 4809', nil),
          CricosScrape::ContactOfficer.new('International Student Contact', 'Matthew Evans', nil, '02 63657537', '02 63657590', 'mevans@csu.edu.au'),
          CricosScrape::ContactOfficer.new('International Student Contact', 'Matthew Evans', nil, '02 6365 7537', '02 6365 7590', 'mevans@csu.edu.au')
        ]
        is_expected.to eq data
      end
    end
  end
end