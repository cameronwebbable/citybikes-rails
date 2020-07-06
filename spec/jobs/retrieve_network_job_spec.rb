require 'rails_helper'

RSpec.describe RetrieveNetworkJob, type: :job do
  let(:response) { JSON.parse(File.read('spec/jobs/fixtures/citybikes_response.json'))}
  let(:zipfile) { Pathname.new('public/networks_test.zip') }
  let(:citybike_response) { instance_double(HTTParty::Response, success?: true, parsed_response: response) }
  before(:each) {
    allow(HTTParty).to receive(:get).and_return(citybike_response)
    remove_zipfile
  }
  after(:each) { remove_zipfile }
    
  def remove_zipfile
    if zipfile.exist?
      zipfile.delete
    end
  end

  describe 'before zipped database exists' do    
    context 'successful network api response' do
      it 'produces what is expected' do
        actual_count = response['networks'].count
        RetrieveNetworkJob.perform_now
        networks_count = Network.count

        expect(networks_count).to eq(actual_count)
        expect(zipfile.exist?).to be true
      end
    end
    context 'failed api response' do
      let(:citybike_response) { 
        instance_double(HTTParty::Response, success?: false, parsed_response: {error: 'oops'}) 
      }

      it 'handles failure gracefully' do
        actual_count = 0
        RetrieveNetworkJob.perform_now
        networks_count = Network.count

        expect(networks_count).to eq(actual_count)
        expect(zipfile.exist?).to be false
      end
    end
    context 'api base key changes' do
      let(:citybike_response) { 
        instance_double(HTTParty::Response, success?: true, parsed_response: {'new_base_key': 'oops'}) 
      }

      it 'handles networks key missing gracefully' do
        expected_count = 0
        RetrieveNetworkJob.perform_now
        networks_count = Network.count

        expect(networks_count).to eq(expected_count)
        expect(zipfile.exist?).to be false
      end
    end
  end

  describe 'after zip exists' do
    it 'should be able to write to a zip, even if it already exists' do
      expect(zipfile.exist?).to be false
      RetrieveNetworkJob.perform_now
      expect(zipfile.exist?).to be true
      RetrieveNetworkJob.perform_now
      expect(zipfile.exist?).to be true
    end
  end
end

