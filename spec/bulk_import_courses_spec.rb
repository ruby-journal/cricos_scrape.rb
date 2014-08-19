require 'spec_helper'

describe CricosScrape::BulkImportCourses do

  describe '#perform' do
    let(:output_file) { {'data' => 'spec_courses.json', 'ids' => 'spec_course_ids.json'} }
    subject(:importer) { CricosScrape::BulkImportCourses.new(output_file, min_id, max_id, input) }
    
    before do
      FileUtils.rm_rf(Dir[data_file_path("spec_*")])
      allow_any_instance_of(CricosScrape::CourseImporter).to receive(:scrape_course).and_return(CricosScrape::Course.new(3), CricosScrape::Course.new(4))
    end

    context 'when no input file provided' do
      let(:min_id) { 3 }
      let(:max_id) { 4 }
      let(:input) { nil }
      let(:course_data_result) { [CricosScrape::Course.new(3), CricosScrape::Course.new(4)].to_json }
      let(:course_ids_result) { [3, 4].to_json }

      context 'given course exists' do
        context 'when successful data storage' do
          let!(:output) { capture_stdout { importer.perform } }

          it 'outputs success message' do
            expect(output).to include "Success with CourseID"
          end

          it 'stores courses data file' do
            expect(File.read(data_file_path(output_file['data']))).to eq course_data_result
          end

          it 'stores course ids file' do
            expect(File.read(data_file_path(output_file['ids']))).to eq course_ids_result
          end
        end

        context 'when failed to save data' do
          before { allow_any_instance_of(CricosScrape::JsonFileStore).to receive(:save).and_raise() }
          let!(:output) { capture_stdout { importer.perform } }

          it 'outputs error message' do
            expect(output).to include "Error writing to files with CourseID"
          end
        end
      end

      context 'when course is not exist ' do
        before { allow_any_instance_of(CricosScrape::CourseImporter).to receive(:scrape_course).and_return(nil) }
        let!(:output) { capture_stdout { importer.perform } }

        it 'does not store courses data to file' do
          expect(File.exist?(data_file_path(output_file['data']))).to be false
        end

        it 'does not store course ids to file' do
          expect(File.exist?(data_file_path(output_file['ids']))).to be false
        end

        it 'outputs error message' do
          expect(output).to include "entered is invalid - please try another."
        end
      end
    end

    context 'when have input file' do
      let(:min_id) { nil }
      let(:max_id) { nil }
      let(:input) { 'data/tmp_input' }
      let(:course_ids_result) { [1, 2, 3, 5].to_json }

      before do
        File.open(input, 'w') {|f| f.write("1,2,3,5") }
        #hide puts string on cli
        allow_any_instance_of(IO).to receive(:puts)
        importer.perform
      end

      it 'stores course ids file' do
        expect(File.read(data_file_path(output_file['ids']))).to eq course_ids_result
      end
    end
  end
end