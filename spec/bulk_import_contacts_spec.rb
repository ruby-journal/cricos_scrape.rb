require 'spec_helper'

describe BulkImportContacts do

  describe '#perform' do
    subject(:bulk_import_contacts) { BulkImportContacts.new('spec_contacts.json', overwrite) }
    
    before do
      FileUtils.rm_rf(Dir[data_file_path("spec_*")])
      allow_any_instance_of(CricosScrape::ContactImporter).to receive(:scrape_contact).and_return(Contact.new)
    end

    context 'when does not overwrite contacts data file' do
      let(:overwrite) { false }

      context 'when does not exist contacts data file' do
        before { allow_any_instance_of(JsonFileStore).to receive(:data_file_empty?).and_return(true) }
        let!(:output) { capture_stdout { bulk_import_contacts.perform } }

        it 'says "Success to get Contacts" when ran' do
          expect(output).to include "Success to get Contacts"
        end

        it 'stores contacts data file' do
          expect(File.read(data_file_path('spec_contacts.json'))).to eq [Contact.new].to_json
        end

      end

      context 'when existing contacts data file' do
        before { allow_any_instance_of(JsonFileStore).to receive(:data_file_empty?).and_return(false) }
        let!(:output) { capture_stdout { bulk_import_contacts.perform } }

        it 'says "Contacts have been taken" when ran' do
          expect(output).to include "Contacts have been taken"
        end
      end
    end

    context 'when overwrite contacts data file' do
      let(:overwrite) { true }

      context 'when existing contacts data file' do
        before { allow_any_instance_of(JsonFileStore).to receive(:data_file_empty?).and_return(false) }
        let!(:output) { capture_stdout { bulk_import_contacts.perform } }

        it 'says "Success to get Contacts" when ran' do
          expect(output).to include "Success to get Contacts"
        end
      end

      context 'when fail data storage' do
        before { allow_any_instance_of(JsonFileStore).to receive(:save).and_raise() }
        let!(:output) { capture_stdout { bulk_import_contacts.perform } }

        it 'says "An error occurred when scrape contacts" when raise error' do
          expect(output).to include "An error occurred when scrape contacts"
        end
      end
    end
  end
end