require 'spec_helper'

describe CricosScrape::JsonFileStore do

  describe '#save' do
    let(:output) { 'spec_json_file_store.json' }
    let(:institution1) { CricosScrape::Institution.new(1) }
    subject(:json_file) { CricosScrape::JsonFileStore.new(output) }
    
    context 'when save data to new file' do
      context 'when file doesnt exist' do
        before { FileUtils.rm_rf(data_file_path(output)) }

        context 'when entity is array' do
          let(:entity) { [institution1] }
          before { json_file.save(entity) }

          it 'creates new data file' do
            expect(File.exist?(data_file_path(output))).to be true
          end
        end

        context 'when entity is struct' do
          let(:entity) { institution1 }
          before { json_file.save(entity) }

          it 'creates new data file' do
            expect(File.exist?(data_file_path(output))).to be true
          end
        end
      end

      context 'when file exist' do
        context 'when empty file' do
          before do
            FileUtils.touch(data_file_path(output))
            json_file.save(institution1)
          end

          it 'creates new data file' do
            expect(File.exist?(data_file_path(output))).to be true
          end
        end
      end
    end

    context 'when append data to exist file' do
      context 'when file has data' do
        let(:institution2) { CricosScrape::Institution.new(2) }
        before do
          File.open(data_file_path(output), 'w') { |f| f.write([institution1].to_json) }
          json_file.save(institution2)
        end

        it 'appends data to file' do
          expect(File.read(data_file_path(output))).to eq [institution1, institution2].to_json
        end

        context 'when rollback file' do
          before { json_file.rollback }

          it 'rollbacks old data' do
            expect(File.read(data_file_path(output))).to eq [institution1].to_json
          end
        end
      end
    end
  end
end