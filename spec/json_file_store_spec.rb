require 'spec_helper'

describe JsonFileStore do

  describe '#save' do
    let(:results_file) { 'spec_json_file_store.json' }
    let(:institution1) { Institution.new(1) }
    subject(:json_file) { JsonFileStore.new(results_file) }
    
    context 'when #empty_data_file? is true' do
      context 'when does not exist file' do
        before { FileUtils.rm_rf(data_file_path(results_file)) }

        context 'when entity is array' do
          let(:entity) { [institution1] }
          before { json_file.save(entity) }

          it 'creates new data file' do
            expect(File.exist?(data_file_path(results_file))).to be true
          end
        end

        context 'when entity is struct' do
          let(:entity) { institution1 }
          before { json_file.save(entity) }

          it 'creates new data file' do
            expect(File.exist?(data_file_path(results_file))).to be true
          end
        end
      end

      context 'when exist file' do
        context 'when empty file' do
          before do
            FileUtils.touch(data_file_path(results_file))
            json_file.save(institution1)
          end

          it 'creates new data file' do
            expect(File.exist?(data_file_path(results_file))).to be true
          end
        end

        context 'when contains data in file' do
          let(:institution2) { Institution.new(2) }
          before do
            File.open(data_file_path(results_file), 'w') { |f| f.write([institution1].to_json) }
            json_file.save(institution2)
          end

          it 'appends data to file' do
            expect(File.read(data_file_path(results_file))).to eq [institution1, institution2].to_json
          end
        end
      end
    end
  end
end