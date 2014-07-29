require 'spec_helper'

describe BulkImportInstitutions do

  describe '#perform' do
    let(:results_file) { {'data' => 'spec_institutions.json', 'ids' => 'spec_institution_ids.json'} }
    subject(:bulk_import_institutions) { BulkImportInstitutions.new(results_file, id_min, id_max, id_file) }
    
    before do
      FileUtils.rm_rf(Dir[data_file_path("spec_*")])
      allow_any_instance_of(CricosScrape::InstitutionImporter).to receive(:scrape_institution).and_return(Institution.new(3), Institution.new(4))
    end

    context 'when scrape institution with id_min and id_max' do
      let(:id_min) { 3 }
      let(:id_max) { 4 }
      let(:id_file) { nil }

      context 'when #institution_existed? is true' do
        context 'when successful data storage' do
          let!(:output) { capture_stdout { bulk_import_institutions.perform } }

          it 'returns id_range id_min..id_max' do
            id_range = bulk_import_institutions.send(:id_range)
            expect(id_range).to eq 3..4
          end

          it 'says "Success with ProviderID #ID" when ran' do
            expect(output).to include "Success with ProviderID"
          end

          it 'stores institutions data file' do
            expect(File.read(data_file_path(results_file['data']))).to eq [Institution.new(3), Institution.new(4)].to_json
          end

          it 'stores institution ids file' do
            expect(File.read(data_file_path(results_file['ids']))).to eq [3, 4].to_json
          end
        end

        context 'when fail data storage' do
          before { allow_any_instance_of(JsonFileStore).to receive(:save).and_raise() }
          let!(:output) { capture_stdout { bulk_import_institutions.perform } }

          it 'says "An error occurred with ProviderID #ID" when raise error' do
            expect(output).to include "An error occurred with ProviderID"
          end
        end
      end

      context 'when #institution_existed? is false' do
        before do
          allow_any_instance_of(CricosScrape::InstitutionImporter).to receive(:scrape_institution).and_return(nil)
          bulk_import_institutions.perform
        end

        it 'does not store institutions data to file' do
          expect(File.exist?(data_file_path(results_file['data']))).to be false
        end

        it 'does not store institution ids to file' do
          expect(File.exist?(data_file_path(results_file['ids']))).to be false
        end
      end
    end

    context 'when scrape institution with id_file' do
      let(:id_min) { nil }
      let(:id_max) { nil }
      let(:id_file) { 'data/tmp_id_file' }

      before do
        File.open(id_file, 'w') {|f| f.write("5,6,15,20") }
        #hide puts string on cli
        allow_any_instance_of(IO).to receive(:puts)
        bulk_import_institutions.perform
      end

      it 'returns id_range from id_file' do
        id_range = bulk_import_institutions.send(:id_range)
        expect(id_range).to eq [5,6,15,20]
      end
    end
  end
end